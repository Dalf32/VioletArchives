require 'chronic_duration'
require 'violet_archives'
require 'violet_archives/input/jargon_parser'
require 'violet_archives/output/dota_text_formatter'
require 'violet_archives/output/printer'
require 'violet_archives/storage/json_file_repo'
require_relative 'console_config'

include VioletArchives

urls = DotaServiceUrls.new('http://www.dota2.com/datafeed',
                           item_list_path: 'itemlist?language=english',
                           ability_list_path: 'abilitylist?language=english',
                           hero_list_path: 'herolist?language=english',
                           item_data_path: 'itemdata?language=english&item_id=',
                           ability_data_path: 'abilitydata?language=english&ability_id=',
                           hero_data_path: 'herodata?language=english&hero_id=')
dota_service = DotaService.new(urls)
repo = JsonFileRepo.new('data')
dota_dataset = DotaData.new(repo, dota_service)

formatter = DotaTextFormatter.new(dota_dataset)
printer = Printer.new('output.txt')

jargon = JargonParser.with_defaults(hero_abbrevs: HERO_ABBREVS, item_abbrevs: ITEM_ABBREVS)

active_patches = PatchSet.new(dota_dataset.patches_with_number(dota_dataset.current_patch.base_number))
patch_mode = "number #{dota_dataset.current_patch.base_number}"

loop do
  printer.print 'dota> '
  input = gets.strip.downcase
  printer.write("#{input}\n")

  case input
  when nil, ''
    # do nothing
  when 'exit', 'close', 'quit'
    break
  when 'help'
    printer.puts <<~HELP
      Available commands:
        last patch, latest patch, current patch - Shows the number of the current patch
        patch mode - Changes which patches are considered for subsequent commands (all, latest only, recent N, current number, time)
        list patches, patches - Lists all considered patches
        buffed - Details of the N most buffed Heroes, or all buffed if no number is given
        nerfed - Details of the N most nerfed Heroes, or all nerfed if no number is given
        most buffed - Details of the most buffed Hero, shortcut for buffed 1
        most nerfed - Details of the most nerfed Hero, shortcut for nerfed 1
        trend - Shows total change from each patch for the given Hero or Item
        info - Shows details of the current state of the given Hero, Ability, or Item

      You may also enter a Hero or Item name to display details of the changes to it
      Multiword commands may also be entered as one word (e.g. latestpatch)
    HELP
  when 'last patch', 'lastpatch', 'latestpatch', 'latest patch', 'currentpatch', 'current patch'
    printer.puts dota_dataset.current_patch
  when 'list patches', 'listpatches', 'patches'
    printer.puts active_patches
  when /\Apatch mode/, /\Apatchmode/
    mode = input.sub(/\Apatchmode|\Apatch mode/, '').strip

    case mode
    when 'latest', 'last', 'current'
      active_patches = PatchSet.new(dota_dataset.current_patch)
      patch_mode = 'latest'
      printer.puts 'Mode set to latest patch only.'
    when /\Arecent/
      num = mode.split.last.to_i
      num = 5 if num.zero?

      active_patches = PatchSet.new(dota_dataset.recent_patches(num))
      patch_mode = "recent #{num}"
      printer.puts "Mode set to the most recent #{num} patches."
    when 'all'
      active_patches = PatchSet.new(dota_dataset.patches)
      patch_mode = 'all'
      printer.puts 'Mode set to all patches.'
    when /\Anumber/
      patch_num = Patch.base_number(mode.sub(/\Anumber/, '').strip)
      patch_num = dota_dataset.current_patch.base_number if patch_num.empty?

      selected_patches = dota_dataset.patches_with_number(patch_num)
      if selected_patches.empty?
        printer.puts 'No patches with that number.'
        next
      end

      active_patches = PatchSet.new(selected_patches)
      patch_mode = "number #{patch_num}"
      printer.puts "Mode set to only #{patch_num} patches."
    when /\Atime/, /\Atimeframe/
      time_frame = ChronicDuration.parse(mode.sub(/\Atime|\Atimeframe/, '').strip)
      if time_frame.nil?
        printer.puts 'Invalid time frame.'
        next
      end

      selected_patches = dota_dataset.patches_since(Time.now.to_i - time_frame)
      if selected_patches.empty?
        printer.puts 'No patches in that time frame.'
        next
      end

      active_patches = PatchSet.new(selected_patches)
      patch_mode = "time #{ChronicDuration.output(time_frame, units: 2)}"
      printer.puts "Mode set to patches from the last #{ChronicDuration.output(time_frame, format: :long, units: 2)}."
    when ''
      plurality = active_patches.single? ? '' : 'es'
      printer.puts "Current mode is '#{patch_mode}' (#{active_patches.count} patch#{plurality})."
    else
      printer.puts 'Supported patch modes: latest, recent [count], all, number [patch_num], time <time_frame>'
    end
  when 'most buffed', 'mostbuffed'
    printer.puts formatter.format_entities(active_patches.buffed_heroes(1))
  when 'most nerfed', 'mostnerfed'
    printer.puts formatter.format_entities(active_patches.nerfed_heroes(1))
  when /\Abuffed/
    num = input.split.last.to_i

    printer.puts formatter.format_entities(active_patches.buffed_heroes(num))
  when /\Anerfed/
    num = input.split.last.to_i

    printer.puts formatter.format_entities(active_patches.nerfed_heroes(num))
  when /\Atrend/
    name = jargon.translate(input.sub(/\Atrend/, '').strip)
    printer.puts 'Unrecognized.' and next if name.empty?

    hero_id = dota_dataset.hero_id_by_name(name)
    item_id = dota_dataset.item_id_by_name(name)
    found_changes = []

    if !hero_id.nil?
      found_changes = active_patches.hero_changes_with_num(hero_id)
    elsif !item_id.nil?
      found_changes = active_patches.item_changes_with_num(item_id)
    else
      printer.puts 'Unrecognized.'
      next
    end

    printer.puts formatter.format_trend(found_changes)
  when /\Ainfo/
    name = jargon.translate(input.sub(/\Ainfo/, '').strip)
    printer.puts 'Unrecognized.' and next if name.empty?

    entity_id = dota_dataset.hero_id_by_name(name)
    unless entity_id.nil?
      printer.puts formatter.format_hero(dota_dataset.hero_data(entity_id)).strip
      next
    end

    entity_id = dota_dataset.item_id_by_name(name)
    unless entity_id.nil?
      printer.puts formatter.format_item(dota_dataset.item_data(entity_id)).strip
      next
    end

    entity_id = dota_dataset.ability_id_by_name(name)
    unless entity_id.nil?
      printer.puts formatter.format_ability(dota_dataset.ability_data(entity_id)).strip
      next
    end

    printer.puts 'Unrecognized.'
  else
    name = jargon.translate(input)
    hero_id = dota_dataset.hero_id_by_name(name)
    item_id = dota_dataset.item_id_by_name(name)
    found_changes = []

    if !hero_id.nil?
      found_changes = active_patches.hero_changes(hero_id).reduce(&:merge)
    elsif !item_id.nil?
      found_changes = active_patches.item_changes(item_id).reduce(&:merge)
    else
      printer.puts 'Unrecognized.'
      next
    end

    printer.puts formatter.format_entity(found_changes)
  end
end

printer.close
