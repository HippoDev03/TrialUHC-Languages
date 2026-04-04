#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "yaml"

ROOT = File.expand_path("..", __dir__)
BASE_FILE = File.join(ROOT, "messages.yml")
REPORT_DIR = File.join(ROOT, "missing")

def flatten_messages(node, prefix = nil, result = {})
  case node
  when Hash
    node.each do |key, value|
      path = prefix ? "#{prefix}.#{key}" : key.to_s
      flatten_messages(value, path, result)
    end
  else
    result[prefix] = node
  end
  result
end

def missing_value?(value)
  return true if value.nil?
  return value.strip.empty? if value.is_a?(String)
  return value.empty? if value.is_a?(Array) || value.is_a?(Hash)

  false
end

def locale_label(file_name)
  return "default" if file_name == "messages.yml"

  file_name
    .sub(/\Amessages[_-]?/i, "")
    .sub(/\.ya?ml\z/i, "")
end

abort("Base language file not found: #{BASE_FILE}") unless File.file?(BASE_FILE)

base_data = YAML.load_file(BASE_FILE) || {}
base_keys = flatten_messages(base_data).keys.sort

FileUtils.rm_rf(REPORT_DIR)
FileUtils.mkdir_p(REPORT_DIR)

language_files = Dir.children(ROOT)
  .select { |name| name.match?(/\Amessages([_-].+)?\.ya?ml\z/i) }
  .reject { |name| name == "messages.yml" }
  .sort

summary_lines = ["# Missing Translation Report", ""]
total_missing = 0

language_files.each do |file_name|
  file_path = File.join(ROOT, file_name)
  data = YAML.load_file(file_path) || {}
  flattened = flatten_messages(data)
  missing_keys = base_keys.select { |key| missing_value?(flattened[key]) }
  total_missing += missing_keys.size

  report_name = file_name.sub(/\.ya?ml\z/i, ".md")
  report_path = File.join(REPORT_DIR, report_name)

  lines = []
  lines << "# Missing keys for `#{file_name}`"
  lines << ""
  lines << "- Locale: `#{locale_label(file_name)}`"
  lines << "- Missing keys: `#{missing_keys.size}`"
  lines << ""

  if missing_keys.empty?
    lines << "No missing keys."
  else
    lines << "## Missing"
    lines << ""
    missing_keys.each do |key|
      lines << "- `#{key}`"
    end
  end

  File.write(report_path, lines.join("\n") + "\n")
  summary_lines << "- `#{file_name}`: #{missing_keys.size} missing"
end

summary_lines << ""
summary_lines << "Total missing keys: `#{total_missing}`"

File.write(File.join(REPORT_DIR, "SUMMARY.md"), summary_lines.join("\n") + "\n")

puts "Generated reports in #{REPORT_DIR}"
puts "Total missing keys: #{total_missing}"

exit(total_missing.zero? ? 0 : 1)
