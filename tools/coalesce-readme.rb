#!/usr/bin/env ruby

# Based on https://github.com/asciidoctor/asciidoctor-extensions-lab/blob/master/scripts/asciidoc-coalescer.rb

require 'asciidoctor'
require 'optparse'

GH_ORGAZNIZATION = 'malston'
GH_REPOSITORY = 'jenkins-declarative-cf-pipeline'
GH_BRANCH = 'master'
DOCS_BASE_URL = [
  'https://raw.githubusercontent.com',
  GH_ORGAZNIZATION,
  GH_REPOSITORY,
  GH_BRANCH
].join('/')

options = {}
OptionParser.new do |o|
  o.banner = 'Usage: ruby coalesce-readme.rb -i <input file> -o <output file>'
  o.on('-i', '--input FILE', 'Input file') do |input|
    options[:input] = input.strip
  end
  o.on('-o', '--output FILE', 'Write output to FILE instead of stdout.') do |output|
    options[:output] = output.strip unless output.strip == '-'
  end
end.parse!

doc = Asciidoctor.load_file options[:input],
                            safe:       :unsafe,
                            parse:      false,
                            attributes: 'allow-uri-read'

out = <<-EOF.gsub(/^\s+/, '')
  // Do not edit this file (e.g. go instead to docs/)
  :jenkins-root-docs: #{DOCS_BASE_URL}/docs/img/jenkins
  :demo-root-docs: #{DOCS_BASE_URL}/docs/img/demo
  :concourse-root-docs: #{DOCS_BASE_URL}/docs/img/concourse
  :intro-root-docs: #{DOCS_BASE_URL}/docs/img/intro
EOF

out << doc.reader.read

if options[:output]
  File.open(options[:output], 'w+') do |f|
    f.write(out)
  end
else
  puts out
end
