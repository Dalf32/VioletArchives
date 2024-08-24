# Behavior Bitflag Constants
DOTA_ABILITY_BEHAVIOR_NONE = 0
DOTA_ABILITY_BEHAVIOR_HIDDEN = 1 # Ability doesn't appear on the HUD.
DOTA_ABILITY_BEHAVIOR_PASSIVE = 2 # Ability is classified as passive, and cannot be pressed.
DOTA_ABILITY_BEHAVIOR_NO_TARGET = 4 # Ability fires immediately when pressed.
DOTA_ABILITY_BEHAVIOR_UNIT_TARGET = 8 # Ability needs a unit target to be cast.
DOTA_ABILITY_BEHAVIOR_POINT = 16 # Ability needs a target point to be cast.
DOTA_ABILITY_BEHAVIOR_AOE = 32 # Ability is considered an AoE ability, respecting "AOERadius" KV when drawing the AoE overlay.
DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE = 64 # Ability cannot be skilled.
DOTA_ABILITY_BEHAVIOR_CHANNELLED = 128 # Ability is considered a channeling ability.
DOTA_ABILITY_BEHAVIOR_ITEM = 256
DOTA_ABILITY_BEHAVIOR_TOGGLE = 512 # Ability can be toggled on and off.
DOTA_ABILITY_BEHAVIOR_DIRECTIONAL = 1024
DOTA_ABILITY_BEHAVIOR_IMMEDIATE = 2048 # Ability ignores cast points and is fired as soon as the skill is pressed.
DOTA_ABILITY_BEHAVIOR_AUTOCAST = 4096 # Ability can be set to auto cast.
DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET = 8192
DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT = 16_384
DOTA_ABILITY_BEHAVIOR_OPTIONAL_NO_TARGET = 32_768
DOTA_ABILITY_BEHAVIOR_AURA = 65_536 # Ability is considered an aura.
DOTA_ABILITY_BEHAVIOR_ATTACK = 131_072
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT = 262_144 # After casting that ability, the caster won't resume its last order.
DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES = 524_288 # Ability cannot be cast while rooted.
DOTA_ABILITY_BEHAVIOR_UNRESTRICTED = 1_048_576
DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE = 2_097_152
DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL = 4_194_304
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT = 8_388_608 # Ability doesn't stop the caster to be used.
DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET = 16_777_216
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK = 33_554_432 # After using ability, caster won't proceed to attack the nearby enemy (even if set otherwise in options)
DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN = 67_108_864
DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING = 134_217_728 # Ability ignores backswing animation.
DOTA_ABILITY_BEHAVIOR_RUNE_TARGET = 268_435_456 # Ability can target runes.
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL = 536_870_912 # Ability can be used without cancelling the current channel.
DOTA_ABILITY_LAST_BEHAVIOR = 536_870_912

# Target Team Bitflag Constants
DOTA_UNIT_TARGET_TEAM_NONE = 0
DOTA_UNIT_TARGET_TEAM_FRIENDLY = 1 # Targets all those that are in the same team as the team that was declared the source.
DOTA_UNIT_TARGET_TEAM_ENEMY = 2 # Targets all those that are not in the same team as the team that was declared the source.
DOTA_UNIT_TARGET_TEAM_BOTH = 3 # Targets all entities from every team.
DOTA_UNIT_TARGET_TEAM_CUSTOM = 4

# Target Type Bitflag Constants
DOTA_UNIT_TARGET_NONE = 0
DOTA_UNIT_TARGET_HERO = 1 # Targets heroes.
DOTA_UNIT_TARGET_CREEP = 2 # Targets creeps.
DOTA_UNIT_TARGET_BUILDING = 4 # Targets buildings.
DOTA_UNIT_TARGET_MECHANICAL = 8 # Deprecated.
DOTA_UNIT_TARGET_COURIER = 16 # Targets couriers.
DOTA_UNIT_TARGET_BASIC = 18 # Targets units. (not necessarily creeps)
DOTA_UNIT_TARGET_OTHER = 32
DOTA_UNIT_TARGET_ALL = 63 # Targets everything (including buildings, couriers, Shrines etc)
DOTA_UNIT_TARGET_TREE = 64 # Targets trees.
DOTA_UNIT_TARGET_CUSTOM = 128

# Target Flags Bitflag Constants
DOTA_UNIT_TARGET_FLAG_NONE = 0 # No special flag rules.
DOTA_UNIT_TARGET_FLAG_RANGED_ONLY = 2 # Targets only ranged units and heroes.
DOTA_UNIT_TARGET_FLAG_MELEE_ONLY = 4 # Targets only melee units and heroes.
DOTA_UNIT_TARGET_FLAG_DEAD = 8 # Targets dead units and heroes as well.
DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES = 16 # Targets magic immune enemies as well.
DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES = 32 # Targets non-magic immune allies as well.
DOTA_UNIT_TARGET_FLAG_INVULNERABLE = 64 # Targets invulnerable units/heroes as well.
DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE = 128 # Targets only those that are visible through the fog of war.
DOTA_UNIT_TARGET_FLAG_NO_INVIS = 256 # Targets only those that are not invisible.
DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS = 512 # Targets only those that are not considered ancients.
DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED = 1024 # Targets player controlled units (ignores the rest of basic units).
DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED = 2048 # Targets only those that are not being dominated.
DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED = 4096 # Targets only those that are not summoned creatures.
DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS = 8192 # Targets only those that are not illusions.
DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE = 16_384 # Targets only those that are not immune to attacks.
DOTA_UNIT_TARGET_FLAG_MANA_ONLY = 32_768 # Targets only those that has a mana bar.
DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP = 65_536
DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO = 131_072 # Targets only those that are not considered creep heroes.
DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD = 262_144 # Targets units/heroes that are hidden as well.
DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED = 524_288 # Targets only those that are not nightmared.

# Damage Type Bitflag Constants
DAMAGE_TYPE_NONE = 0
DAMAGE_TYPE_PHYSICAL = 1 # Physical, reduced by armor.
DAMAGE_TYPE_MAGICAL = 2 # Magical, reduced by magic resistance.
DAMAGE_TYPE_PURE = 4 # Pure, not reduced by anything.
DAMAGE_TYPE_ALL = 7
DAMAGE_TYPE_HP_REMOVAL = 8 # Deprecated.
