require 'violet_archives'
require 'violet_archives/storage/json_file_repo'

include VioletArchives

urls = DotaServiceUrls.new('http://www.dota2.com/datafeed',
                           patch_list_path: 'patchnoteslist?language=english',
                           patch_notes_path: 'patchnotes?language=english&version=')
dota_service = DotaService.new(urls)
repo = JsonFileRepo.new('data')

patches = dota_service.patch_list

patches['patches'].reverse.each do |patch_hash|
  patch_num = patch_hash['patch_number']
  puts "Loading patch #{patch_num}"

  patch = PatchBuilder.build_patch(dota_service.patch_notes(patch_num))

  print '  Scoring changes... '
  changes = patch.item_changes.flat_map(&:all_changes) +
            patch.neutral_changes.flat_map(&:all_changes) +
            patch.hero_changes.flat_map(&:all_changes)

  ChangeScorer.score_changes(changes)
  puts 'Done.'

  print '  Saving patch... '
  repo.save_patch(patch)
  puts 'Done.'

  break if ARGV.first&.downcase == 'latest' # only run once
end
