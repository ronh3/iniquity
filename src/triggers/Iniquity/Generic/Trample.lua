local limb = matches.limb:gsub(" ", "")
raiseEvent('iniquity', 'afflict', matches.victim, f'broken{limb}')