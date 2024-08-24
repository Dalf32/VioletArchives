require 'json'
require_relative '../model/patch'

module VioletArchives
  # Handles storage for Patch data using a number of JSON files
  class JsonFileRepo
    def initialize(repo_dir)
      @repo_dir = repo_dir
    end

    def load_patches
      ensure_repo_dir
      Dir.open(@repo_dir).select { |file| file.end_with?('.json') }
         .map { |file| Patch.from_hash(JSON.parse(File.readlines(File.join(@repo_dir, file)).join)) }
         .sort_by(&:timestamp).reverse
    end

    def save_patch(patch)
      ensure_repo_dir
      File.open(File.join(@repo_dir, "#{patch.number.gsub('.', '_')}.json"), 'w').tap do |file|
        file << JSON.generate(patch.to_hash)
        file.close
      end
    end

    private

    def ensure_repo_dir
      Dir.mkdir(@repo_dir) unless Dir.exist?(@repo_dir)
    end
  end
end
