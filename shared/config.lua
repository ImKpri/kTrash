CFGpooubelle = {}


CFGpooubelle.Target = false -- true our false         TriggerEvent('esx:garbage:open')  RAGEUI  |   TriggerEvent('envi-dumpsterdive:goDiving', entity)   FOUILLE
 
CFGpooubelle.Cooldown = 30 -- cooldown time (in seconds)

CFGpooubelle.MaxCommonReward = 3 -- max amount of common items you can find
CFGpooubelle.MaxUncommonReward = 2 -- max stack of uncommon items you can find
CFGpooubelle.MaxRareReward = 1 -- max stack of uncommon items you can find

CFGpooubelle.CommonRewards = { -- common items that can be found in dumpsters - (60% chance)
    'bread',
    'water',
    'acide',
    'vodka',
}

CFGpooubelle.UncommonRewards = { -- uncommon items that can be found in dumpsters - (25% chance)
    'spray_remover',
    'water',
    'soda',
    'burger',
}

CFGpooubelle.RareRewards = { -- rare items that can be found in dumpsters - (5% chance)
    'fishingrod',
    'bmx',
    'kScratchCard',
    'phone',
    'toolbox',

}