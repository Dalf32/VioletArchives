module VioletArchives
  # Translates common abbreviations, legacy names, and nicknames to the actual
  # Dota 2 entity names
  class JargonParser
    def self.with_defaults(hero_abbrevs: {}, item_abbrevs: {}, ability_abbrevs: {})
      JargonParser.new(hero_abbrevs: DEFAULT_HERO_ABBREVS.merge(hero_abbrevs),
                       item_abbrevs: DEFAULT_ITEM_ABBREVS.merge(item_abbrevs),
                       ability_abbrevs: DEFAULT_ABILITY_ABBREVS.merge(ability_abbrevs))
    end

    def initialize(hero_abbrevs: {}, item_abbrevs: {}, ability_abbrevs: {})
      @hero_abbrevs = hero_abbrevs
      @item_abbrevs = item_abbrevs
      @ability_abbrevs = ability_abbrevs
    end

    def translate(input)
      input = input.downcase
      @hero_abbrevs[input] || @item_abbrevs[input] || @ability_abbrevs[input] || input
    end

    def translate_hero(input)
      translate_for(input, @hero_abbrevs)
    end

    def translate_item(input)
      translate_for(input, @item_abbrevs)
    end

    def translate_ability(input)
      translate_for(input, @ability_abbrevs)
    end

    DEFAULT_HERO_ABBREVS = {
      'aba' => 'abaddon', 'abba' => 'abaddon',
      'alch' => 'alchemist',
      'aa' => 'ancient apparition',
      'am' => 'anti-mage',
      'bh' => 'bounty hunter', 'bounty' => 'bounty hunter',
      'brew' => 'brewmaster',
      'bristle' => 'bristleback',
      'brood' => 'broodmother',
      'centaur' => 'centaur warrunner',
      'ck' => 'chaos knight',
      'clock' => 'clockwerk',
      'cm' => 'crystal maiden',
      'willow' => 'dark willow',
      'dawn' => 'dawnbreaker',
      'dp' => 'death prophet',
      'dk' => 'dragon knight',
      'drow' => 'drow ranger',
      'shaker' => 'earthshaker',
      'et' => 'elder titan',
      'ember' => 'ember spirit',
      'ench' => 'enchantress',
      'grim' => 'grimstroke',
      'gyro' => 'gyrocopter',
      'wisp' => 'io',
      'jug' => 'juggernaut', 'jugg' => 'juggernaut',
      'kotl' => 'keeper of the light',
      'legion' => 'legion commander', 'lc' => 'legion commander',
      'lesh' => 'leshrac',
      'naix' => 'lifestealer',
      'ld' => 'lone druid',
      'mag' => 'magnus',
      'dusa' => 'medusa',
      'potm' => 'mirana',
      'mk' => 'monkey king', 'monkey' => 'monkey king',
      'morph' => 'morphling',
      'naga' => 'naga siren',
      'np' => "nature's prophet", 'furion' => "nature's prophet",
      'necro' => 'necrophos',
      'ns' => 'night stalker',
      'nyx' => 'nyx assassin',
      'ogre' => 'ogre magi',
      'omni' => 'omniknight',
      'od' => 'outworld destroyer',
      'pango' => 'pangolier',
      'pa' => 'phantom assassin',
      'pl' => 'phantom lancer',
      'primal' => 'primal beast', 'pb' => 'primal beast',
      'qop' => 'queen of pain',
      'sk' => 'sand king',
      'sd' => 'shadow demon',
      'sf' => 'shadow fiend',
      'shaman' => 'shadow shaman',
      'skywrath' => 'skywrath mage',
      'snap' => 'snapfire',
      'sb' => 'spirit breaker', 'breaker' => 'spirit breaker',
      'storm' => 'storm spirit',
      'ta' => 'templar assassin',
      'tb' => 'terrorblade',
      'tide' => 'tidehunter',
      'timber' => 'timbersaw',
      'treant' => 'treant protector', 'tree' => 'treant protector',
      'troll' => 'troll warlord',
      'dirge' => 'undying',
      'venge' => 'vengeful spirit',
      'veno' => 'venomancer',
      'windrunner' => 'windranger',
      'wyvern' => 'winter wyvern'
    }.freeze

    DEFAULT_ITEM_ABBREVS = {
      'shard' => "aghanim's shard",
      'dust' => 'dust of appearance',
      'mango' => 'enchanted mango',
      'salve' => 'healing salve',
      'observer' => 'observer ward',
      'sentry' => 'sentry ward',
      'smoke' => 'smoke of deceit',
      'tp' => 'town portal scroll',
      'branch' => 'iron branch',
      'raindrops' => 'infused raindrops',
      'blink' => 'blink dagger', 'dagger' => 'blink dagger',
      'gem' => 'gem of true sight',
      'stick' => 'magic stick',
      'talisman' => 'talisman of evasion',
      'bots' => 'boots of travel', 'travels' => 'boots of travel',
      'bots 2' => 'boots of travel 2',
      'midas' => 'hand of midas',
      'hod' => 'helm of the dominator', 'dom' => 'helm of the dominator',
      'wand' => 'magic wand',
      'mom' => 'mask of madness',
      'null' => 'null talisman',
      'treads' => 'power treads',
      'drums' => 'drum of endurance',
      'greaves' => 'guardian greaves',
      'mek' => 'mekanism',
      'pipe' => 'pipe of insight',
      'basi' => 'ring of basilius',
      'vessel' => 'spirit vessel',
      'tranquils' => 'tranquil boots',
      'urn' => 'urn of shadows',
      'vlads' => "vladimir's offering",
      'scepter' => "aghanim's scepter", 'aghs' => "aghanim's scepter",
      'euls' => "eul's scepter of divinity", 'euls scepter' => "eul's scepter of divinity",
      'glimmer' => 'glimmer cape',
      'octarine' => 'octarine core',
      'orchid' => 'orchid of malevolence',
      'refresher' => 'refresher orb',
      'atos' => 'rod of atos',
      'scythe' => 'scythe of vyse', 'sheepstick' => 'scythe of vyse',
      'veil' => 'veil of discord',
      'aeon' => 'aeon disk',
      'ac' => 'assault cuirass',
      'bkb' => 'black king bar',
      'crimson' => 'crimson guard',
      'shroud' => 'eternal shroud',
      'heart' => 'heart of tarrasque',
      'pike' => 'hurricane pike',
      'linkens' => "linken's sphere",
      'lotus' => 'lotus orb',
      'manta' => 'manta style',
      'shivas' => "shiva's guard",
      'abyssal' => 'abyssal blade',
      'armlet' => 'armlet of mordiggian',
      'crystalis' => 'crystalys',
      'deso' => 'desolator',
      'divine' => 'divine rapier', 'rapier' => 'divine rapier',
      'e blade' => 'ethereal blade',
      'mkb' => 'monkey king bar',
      'nulli' => 'nullifier',
      'brooch' => "revenant's brooch",
      'basher' => 'skull basher',
      'diffu' => 'diffusal blade', 'diffusal' => 'diffusal blade',
      'skadi' => 'eye of skadi',
      'halberd' => "heaven's halberd",
      'k&s' => 'kaya and sange', 'k and s' => 'kaya and sange', 'kns' => 'kaya and sange',
      's&y' => 'sange and yasha', 's and y' => 'sange and yasha', 'sny' => 'sange and yasha',
      'y&k' => 'yasha and kaya', 'y and k' => 'yasha and kaya', 'ynk' => 'yasha and kaya',
      'aegis' => 'aegis of the immortal'
    }.freeze

    DEFAULT_ABILITY_ABBREVS = {
      'call' => "berserker's call",
      'chop' => 'culling blade', 'dunk' => 'culling blade',
      'grip' => "fiend's grip",
      'echo' => 'echo slam',
      'omni' => 'omnislash',
      'arrow' => 'sacred arrow',
      'raze' => 'shadowraze',
      'requiem' => 'requiem of souls',
      'jaunt' => 'ethereal jaunt',
      'coil' => 'dream coil',
      'hook' => 'meat hook',
      'epi' => 'epicenter',
      'swap' => 'nether swap',
      'boat' => 'ghostship',
      'lsa' => 'light strike array',
      'laguna' => 'laguna blade',
      'finger' => 'finger of death',
      'serpent wards' => 'mass serpent ward',
      'amplify damage' => 'corrosive haze',
      'scythe' => "reaper's scythe",
      'rock' => 'chaotic offering', 'golem' => 'chaotic offering',
      'roar' => 'primal roar',
      'chrono' => 'chronosphere',
      'reincarnate' => 'reincarnation',
      'siphon' => 'spirit siphon',
      'exo' => 'exorcism',
      'glaives' => 'moon glaives',
      'dragon form' => 'elder dragon form',
      'grave' => 'shallow grave',
      'cogs' => 'power cogs',
      'vac' => 'vacuum',
      'wall' => 'wall of replica',
      'ga' => 'guardian angel',
      'web' => 'spin web',
      'geminate' => 'geminate attack',
      'macro' => 'macropyre',
      'napalm' => 'sticky napalm',
      'lasso' => 'flaming lasso',
      'flak' => 'flak cannon',
      'emp' => 'e.m.p.',
      'meteor' => 'chaos meteor', 'meatball' => 'chaos meteor',
      'global' => 'global silence',
      'astral' => 'astral imprisonment',
      'hammer' => "sanity's eclipse",
      'split' => 'primal split',
      'carapace' => 'spiked carapace',
      'song' => 'song of the siren',
      'relo' => 'relocate',
      'stomp' => 'hoof stomp',
      'rp' => 'reverse polarity',
      'chains' => 'searing chains',
      'sleight' => 'sleight of fist',
      'meta' => 'metamorphosis',
      'egg' => 'supernova',
      'curse' => "winter's curse",
      'pit' => 'pit of malice',
      'boundless' => 'boundless strike',
      'wukongs' => "wukong's command",
      'swash' => 'swashbuckle',
      'roll' => 'rolling thunder',
      'bramble' => 'bramble maze',
      'spear' => 'spear of mars',
      'rebuke' => "god's rebuke",
      'arena' => 'arena of blood',
      'cookie' => 'firesnap cookie'
    }.freeze

    private

    def translate_for(input, abbrevs)
      input = input.downcase
      abbrevs[input] || input
    end
  end
end
