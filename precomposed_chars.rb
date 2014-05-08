#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"

precomposed = Hash.new {|h, lang| h[lang] = {}}
diacritics  = 0x0300..0x036f

File.load("UnicodeData.txt").each do |line|
  code, name, type, _, _, compose, *_ = line.split(";")

  code = code.to_i(16)
  composed = compose.split.map{|c| c.to_i(16)}

  next unless type.starts_with? "L"

  if composed.present?
    if composed.any?{|c| c.in? diacritics}
      lang = name.split.first
      precomposed[lang][code] = [name, compose]
    end
  end
end

precomposed.each do |lang, precomps|
  puts "#{lang} -> #{precomps.size}"
end
