#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"

precomposed     = Hash.new {|h, lang| h[lang] = {}}
diacritics      = 0x0300..0x036f
used_diacritics = Set.new

File.load("../saneo").each do |line|
  if line =~ /^\s*key /
    unicode_keys = line.scan(/U\d{4}/).map{|c| c[1..-1].to_i(16)}
    used_diacritics += unicode_keys.select{|c| c.in? diacritics}
  end
end

File.load("../UnicodeData.txt").each do |line|
  code, name, type, _, _, compose, *_ = line.split(";")

  code = code.to_i(16)
  composed = compose.split.map{|c| c.to_i(16)}

  next unless type.starts_with? "L"

  if composed.present?
    if composed.any?{|c| c.in? used_diacritics}
      lang = name.split.first
      precomposed[lang][code] = [name, composed]
    end
  end
end

precomposed.each do |lang, precomps|
  puts "#{lang} -> #{precomps.size}"

  prefix  = File.save("precomposed_#{lang.downcase}_prefix.el")
  postfix = File.save("precomposed_#{lang.downcase}_postfix.el")

  [prefix, postfix].each{|f| f.puts "(quail-define-rules"}

  precomps.sort.each do |precomposed, (name, composed)|
    precomposed = [precomposed].pack("U")
    composed    = composed.map{|c| [c].pack("U")}

    prefix.puts  " (\"#{composed.join}\" ?#{precomposed})"
    postfix.puts " (\"#{composed.reverse.join}\" ?#{precomposed})"
  end

  [prefix, postfix].each{|f| f.puts ")"}
end
