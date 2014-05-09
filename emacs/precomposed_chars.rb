#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"
require "unicode_utils"

precomposed = {}
diacritics  = 0x0300..0x036f

used_diacritics = Set.new
used_letters    = Set.new ("a".."z").map(&:ord) # assume we can Latin

File.load("../saneo").each do |line|
  if line =~ /^\s*key /
    key = line[/ \[ ( .+) \]/x, 1].whackuum(",")
    normal, shift, mod3, mod3_shift, mod4, mod4_shift, mod3_mod4 = key

    letter_keys = [
      normal,
      shift,
      mod3,
      mod3_shift
    ].select{|c| c =~ /U\w{4}/}

    diac_keys = [
      mod4,
      mod4_shift
    ].select{|c| c =~ /U\w{4}/}

    diac_keys.each do |c|
      c = c[1..-1].to_i(16)
      used_diacritics << c if c.in? diacritics
    end

    letter_keys.each do |c|
      c = c[1..-1].to_i(16)
      used_letters << c if UnicodeUtils.char_type(c) == :Letter
    end

  end
end

puts "using #{used_letters.size} letters and #{used_diacritics.size} diacritics..."

File.load("../UnicodeData.txt").each do |line|
  code, name, type, _, _, compose, *_ = line.split(";")

  code = code.to_i(16)
  composed = compose.split.map{|c| c.to_i(16)}

  next unless type.starts_with? "L"

  if composed.present?
    if composed.any?{|c| c.in? used_diacritics}
      prec = [code].pack("U")
      comp = composed.map{|c| [c].pack("U")}

      letter, diacritic = composed
      next unless letter.in? used_letters and diacritic.in? used_diacritics

      precomposed[comp.join] = prec
    end
  end
end

used_letters.to_a.product(used_diacritics.to_a).each do |letter, diacritic|
  composed = [letter, diacritic].map{|c| [c].pack("U")}.join

  # fill in gaps with straight pairs so that the input method is consistent
  precomposed[composed] ||= composed
end

# make typing raw diacritics possible
used_diacritics.each do |dia|
  dia = [dia].pack("U")
  precomposed["#{dia}#{dia}"] = dia
end

puts "saving #{precomposed.size} combos..."

prefix  = File.save("precomposed_prefix.el")
postfix = File.save("precomposed_postfix.el")

[prefix, postfix].each{|f| f.puts "(quail-define-rules"}

precomposed.sort_by{|c,p| p}.each do |composed, prec|
  output = case prec.size
           when 1
             "?#{prec}"
           else
             "[\"#{prec}\"]"
           end

  prefix.puts  " (\"#{composed}\" #{output})"
  postfix.puts " (\"#{composed.reverse}\" #{output})"
end

[prefix, postfix].each{|f| f.puts ")"}
