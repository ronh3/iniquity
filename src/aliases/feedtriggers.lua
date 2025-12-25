-- Generate test echoes to fire all known trigger patterns with attacker Veera and victim Trendric.
local victim = "Trendric"
local attacker = "Veera"

local function fill_pattern(pattern)
	-- Trim anchors/leading spaces and simplify common regex tokens.
	local text = pattern:gsub("^%s*%^?", "")
	text = text:gsub("%$", "")
	text = text:gsub("%(%?:left%|right%)", "left") -- choose one side for non-capturing alternations
	local capture_index = 0

	-- Replace captured \S+ groups with victim first, attacker thereafter.
	text = text:gsub("%(\\S%+%)", function()
		capture_index = capture_index + 1
		if capture_index == 1 then
			return victim
		else
			return attacker
		end
	end)

	-- Replace other regex tokens with simple words.
	text = text:gsub("\\S%+", attacker)
	text = text:gsub("\\w%+", "his")
	text = text:gsub("%.%*", "something")
	text = text:gsub("%.%+", "something")
	text = text:gsub("%(%.%*%)", "something")
	text = text:gsub("%(%.%+%)", "something")

	-- Normalize spacing.
	text = text:gsub("%s+", " ")
	text = text:gsub("^%s+", "")
	return text
end

local patterns = {
	-- Magi / Artificing
	[[^As the lightning bolt courses through (\S+), a strangely blank expression descends over \S+ features\.]],

	-- Magi / Emanations
	[[^\S+ sweeps .+ overhead and a great wind rises, picking up (\S+) and casting \S+ violently about before hurling \S+ back to the ground\.]],
	[[^\S+ makes the slightest flick with .+, and like the hand of some angered titan a great wave of water descends to smash down upon (\S+)\.]],

	-- Magi / Resonance
	[[^A loud crack emanates from the (.+) of (\S+)\.]],
	[[^(\S+) buckles under an unseen blow\.]],
	[[^(\S+) hacks and coughs as a series of unpleasant cracks sound in grim staccato from \S+ chest\.]],
	[[^(\S+) clutches at \S+ throat as \S+ gasps for breath\.]],
	[[^A vicious wind rises, lashing and flaying at the body of (\S+) to leave \S+ sensitive and raw\.]],
	[[^A dreadful pallor overcomes the features of (\S+)\.]],
	[[^The air between \S+ and (\S+) ripple with a haze of heat, and flames ignite upon the skin of \S+\.]],
	[[^Blisters burst open across the body of (\S+) as \S+ skin glows as if lit from within\.]],
	[[^A freezing wave of water materialises as if from nothing, crashing down upon (\S+)\.]],
	[[^A flurry of freezing icicles materialise to slash at (\S+) in a shower of freezing daggers\.]],
	[[^\S+ makes no motion or word, but (\S+) turns shockingly pale and staggers as if struck\.]],

	-- Magi / Spells
	[[^The air thrums about \S+ as a flurry of rocks materialise to bombard (\S+)\.]],
	[[^\S+ raises a hand towards (\S+) and blasts \S+ with cold, frigid air\.]],
	[[^\S+ weaves earth and water and a torrent of thick mud thunders forth to roll over (\S+), knocking \S+ sprawling\.]],
	[[^\S+ clicks \S+ fingers and a bolt of lightning strikes from the air in a fulminous flash to transfix (\S+)\.]],
	[[^The skin of (\S+) begins to dry and crack as \S+ grows pale\.]],
	[[^\S+ weaves fire and earth in a complex pattern and bubbling magma boils into existence in a searing tide to crash down upon (\S+)\.]],

	-- Sylvan Need To Verify
	[[^(\S+) stumbles clumsily as the blow lands.]],
	[[^(\S+) begins to shake uncontrollably.]],
	[[^A puzzled expression crosses the face of (\S+).]],
	[[^(\S+) begins to thrash at the water enveloping \S+\.]],

	-- Pariah / Memorium
	[[^(\S+) suddenly sways, \S+ eyes drooping as \S+ sags\.]],
	[[^(\S+) gasps a great lungful of air, \S+ face flushing with sudden colour\.]],
	[[^As the logograph becomes fully formed it burns with a terrible crimson light, and (\S+) recoils back from its arcane brilliance\.]],
	[[^The glowing logograph upon the brow of (\S+) suddenly explodes into searing red light, winking out almost immediately\.]],
	[[^Even as the logograph becomes fully formed it leaps from the air to (\S+), ephemeral claws plunging into \S+ chest\.]],
	[[^Ephemeral claws suddenly thrust from the chest of (\S+), their ghostly edges slicing and rending\.]],
	[[^As the logograph becomes fully formed it leaps for (\S+), ephemeral fangs closing about \S+ throat\.]],
	[[^(\S+) coughs, \S+ face starting to turn blue\.]],
	[[^Something undulates grotesquely within the stomach of (\S+), and a ravenous gleam enters \S+ eyes\.]],
	[[^Something writhes within the stomach of (\S+), \S+ face contorting in a strangely hungry expression\.]],
	[[^As the logograph becomes fully formed it suddenly shatters, (\S+) staggering drunkenly backwards\.]],
	[[^(\S+) staggers suddenly, eyes rolling back in \S+ skull\.]],
	[[^The logograph is still solidifying as it leaps from the air to (\S+), an insubstantial stinger rising and falling thrice in terrible succession before the logograph is gone\.]],

	-- Razes
	[[^\S+ razes? (.+)'s magical shield]],
	[[^\S+ whips up a raging gale of wind, sending it towards (\S+)\.]],
	[[^Impossibly fast, \S+ brings a magma-wreathed fist around, driving it straight through the magical shield surrounding (\S+) without visible effort\.]],
	[[^\S+ conjures a blade of ice and drives it straight through the translucent shield surrounding (\S+), the protection exploding in a shower of prismatic shards\.]],
	[[^The magical shield surrounding (\S+) suddenly shatters for no visible reason, flames spontaneously igniting upon \w+ skin\.]],
	[[^\S+ sends myriad russet streams towards (\S+), shattering \S+ shield\.]],
	[[^\S+'s Baalzadeen stares passively, but powerfully, at (\S+)\.]],
	[[^\S+'?s? daegger flings itself at (\S+)'s translucent shield, piercing through it and causing it to fade\.]],
	[[^\S+ unleashe?s? a burst of Shin energy at (\S+), tearing apart \w+ translucent shield\.]],
	[[^The shadow of \S+ suddenly comes alive, leaping forward to hammer at the magical shield surrounding (\S+) in a silent frenzy of blows\. \w+ protection lasts mere moments before exploding in a shower of prismatic shards\.]],
	[[^As \S+ speaks a terrible word of power, the magical shield surrounding (\S+) shatters into prismatic shards\.]],
	[[^\S+ dismissively flicks \w+ tail at (\S+), annihilating the magical shield surrounding \w+ with casual ease\.]],
	[[^\S+ casts a spell of erosion at (\S+)\.]],
	[[^Huge boulders hammer at the magical shield surrounding (\S+), shattering it in a spray of translucent shards\.]],
	[[The end of \S+'s staff smashes the magical shield surrounding (\S+) in an explosion of translucent shards\.]],
	[[^The magical shield surrounding (\S+) explodes into translucent shards without visible reason or cause\.]],
	[[^\S+ flays? away (\S+)'s shield defence\.]],

	-- Sentinel / Pets
	[[^A grumpy badger carves great gouges in the flesh of (\S+) with its claws\.]],
	[[^A gossamer butterfly goes into a frenzy of motion in front of the eyes of (\S+), and \S+ sways unsteadily\.]],
	[[^A cunning red fox leaps upon (\S+), sinking its teeth into \S+ skin\.]],
	[[^An ebony raven dives down upon (\S+), pecking at \S+ face and eyes\.]],
	[[^A grey wolf lets out a baying howl at (\S+)\.]],
	[[^A grumpy badger lunges at (\S+), claws raking across \S+ throat\.]],

	-- Generic
	[[^(\S+) is gripped with fear, staring out with terrified eyes\.]],
	[[^(\S+)'s eyes close suddenly as \S+ falls asleep\.]],
	[[^(\S+) tosses back and forth in restless slumber\.]],
	[[^\S+ glows with an emerald hue and snaps \S+ fingers at (\S+)\.]],
	[[^(\S+) wakes up with a gasp of pain\.]],
	[[^(\S+) opens \S+ eyes and stretches languidly, a smile on \S+ face\.]],
	[[^(\S+) opens \S+ eyes and yawns mightily\.]],
	[[^(\S+) awakens with a start\.]],
	[[^(\S+) falls to \S+ knees and clutches \S+ ears as the shaft of sound strikes (\S+)\.]],
	[[^The bees sting (\S+) into paralysis\.]],
	[[^(\S+) blinks slowly, and begins to tremble\.]],
	[[^(\S+) begins to pant in terror\.]],
	[[^(\S+) looks about bemusedly\.]],
	[[^(\S+) stiffens suddenly, \S+ features a masque frozen in agony\.]],
	[[^(\S+) lets out a piercing scream, as if wounded by the very sunlight\.]],
	[[A brief look of concentration crosses the face of]],
	[[A brief look of concentration crosses the face of (\S+)]],
	[[^The side of (\S+)'s head is lightly struck by \S+'s rapier\.]],
	[[^(\S+) stares about \S+ frenziedly, wild\-eyed\.]],
	[[^(\S+) begins to jerk and shake violently, foaming at the mouth\.]],
	[[^(\S+) shivers particularly intensely\.]],
	[[^(\S+) seems able to move more freely all of a sudden\.]],
	[[^(\S+) suddenly appears tired all of a sudden\.]],
	[[^(\S+) shuffles (\S+) feet in boredom\.]],
	[[^(\S+) suddenly starts scratching at an itch like mad\.]],
	[[^\S+ eyes gleaming, \S+ smiles and quickly sings a jaunty limerick at (\S+)\.]],
	[[^(\S+) drives a clenched fist into \S+ gut\.]],
	[[^(\S+) uses \S+ right foot to stomp on \S+ left as hard as possible\.]],
	[[^(\S+) smiles as \S+ rams \S+ fist into \S+ jaw\.]],
	[[^With the heel of \S+ palm, (\S+) smacks \S+ upside the head\.]],
	[[^(\S+) uses \S+ \S+ foot to stomp on \S+ \S+ as hard as possible\.]],
	[[^(\S+) pops a mickey into \S+ mouth\.]],
	[[^Ethereal bonds flash forth to bind (\S+) as \S+ gaze falls upon a nairat rune\.]],
	[[^(\S+) doubles over, vomiting violently\.]],
	[[^(\S+) sways unsteadily as \S+ face turns an unpleasant shade of green\.]],
	[[^Horror overcomes (\S+)'s face as (\S+) body stiffens into paralysis\.]],
	[[^(\S+) stiffens suddenly, \S+ features a masque frozen in agony\.]],
	[[^(\S+)'s body stiffens rapidly with paralysis\.]],
	[[^The body of (\S+) locks in paralysis as \S+ directs a short burst of arcane power in \S+ direction\.]],
	[[^Lunging to the side, \S+ brings \S+ shield around to smash into the spine of (\S+)\.]],
	[[^\S+ recites an epic tale of the heroism of Nicator to (\S+)\.]],
	[[^Horror overcomes the face of (\S+) as \S+ body locks in paralysis\.]],
	[[^(\S+)'s limbs suddenly lock up\.]],
	[[The raven dives at ]],
	[[^The raven dives at (\S+) and pulls up short, making \S+ uneasy\.]],
	[[^(\S+)'s eyes are filled with compassion and peace\.]],
	[[^Sweeping out with a blade hand, \S+l strikes at the back of (\S+)'s knee\.]],
	[[^Drawing an enormous breath, \S+ exhales, expelling a gale of wind with such force that (\S+) is knocked over\.]],
	[[^(\S+) is knocked forcefully off \S+ feet by the impact of \S+'s huge tail\.]],
	[[^(\S+)'s eyes close suddenly as \S+ falls asleep\.]],
	[[^(\S+) is knocked off \S+ feet by the heaving ground\.]],
	[[^\S+ throws \S+ palms forward, releasing a stream of deadly blue light to cripple (\S+)\.]],
	[[^You hear two loud snaps and see (\S+) fall to the ground\.]],
	[[^The staff sweeps the legs out from under (\S+), sending \S+ sprawling\.]],
	[[^\S+ drops low, tangling .+ with the legs of (\S+) and sending \S+ sprawling\.]],
	[[^\S+ drops to the floor and sweeps \S+ legs round at (\S+)\.]],
	[[^(\S+) slips on a thin layer of fluid, \S+ feet flying out from under \S+\.]],
	[[^Water thunders down upon (\S+), driving \S+ relentlessly to \S+ knees\.]],
	[[^The \S+ leg of (\S+) buckles under the impact, and \S+ goes sprawling\.]],
	[[ ^\S+ lunges downward, slamming the edge of .* into the shins of (\S+)\.]],
	[[^Sweeping out with a blade hand, \S+ strikes at the back of (\S+)'s knee\.]],
	[[^(\S+) is flung violently from \S+ feet\.]],
	[[^(\S+) has already fallen to the ground\.]],
	[[^(\S+) is swept off \S+ feet by the blast\.]],
	[[^A mighty, bestial roar from \S+ leaves (\S+) looking dazed\.]],
	[[^(\S+) goes down in a tangle of limbs as \S+ legs are swept out from under \S+\.]],
	[[The protective coating covering the skin of]],
	[[^The protective coating covering the skin of (\S+) sloughs off\.]],
	[[^An .* sinks its fangs into the neck of (\S+), injecting a potent dose of toxin\.]],
	[[^A .* sinks its fangs into the neck of (\S+), injecting a potent dose of toxin\.]],
	[[^Tears fill (\S+)'s eyes and begin to slowly run down (\S+) face\.]],
	[[^(\S+) flaps (\S+) arms madly\.]],
	[[^(\S+) stumbles and pokes (\S+) in the eye\.]],
	[[^(\S+) makes a strangled meowing noise and quickly shuts up, blushing\.]],
	[[^(\S+) picks (\S+) nose absently\.]],
	[[^(\S+) breaks down and sobs uncontrollably\.]],
	[[^(\S+) gets down on one knee and serenades the world\.]],
	[[^(\S+) falls to his knees in worship\.]],
	[[^(\S+) grunts a bit and then lets out a loud "OINK!" ]],
	[[^(\S+) wails like an old woman\.]],
	[[^(\S+) moans, holding his head\.]],
	[[^You cast a net of stupidity over (\S+)'s mind\.]],
	[[^(\S+) twitches spasmodically\.]],
	[[^(\S+) fondles \S+ absently\.]],
	[[^(\S+) lets out a loud, long "MOOOOOOOOOOO!" ]],
	[[^(\S+) attempts to do a standing backflip, but merely stumbles over \S+ own feet\.]],
	[[^(\S+) stands up\.]],
	[[^(\S+) rolls smoothly back to \S+ feet\.]],
	[[^(\S+) pushes off the ground, coming back up into a guard position\.]],
	[[^.+ (crushes|pulverises|smashes|breaks) the (.+) of (\S+)\.]],

	-- Occultist / Domination
	[[^A bubonis reaches out and strokes the side of (\S+)'s face, and boils form and rupture in an instant as \S+ begins hacking up black fluid\.]],
	[[^A chimera throws forward all three of its heads and roars at (\S+), but \S+ seems completely unphased\.]],
	[[^Many somethings writhe beneath the skin of (\S+), and the sickening sound of chewing can be heard\.]],
	[[^The gremlin races around and between the legs of (\S+), \S+ eyes tracking it as \S+ sways unsteadily\.]],
	[[^The worm burrowing into (\S+) writhes and undulates\.]],

	-- Occultist / Occultism
	[[^(\S+) trembles and \S+ eyes widen in terror\. \S+ looks around \S+ as if searching for something that isn't there\.]],

	-- Monk / Shikudo
	[[^The staff smashes into the face of (\S+) with a sickening crunch\.]],
	[[^The staff connects to the side of (\S+)'s head with a resounding crack\.]],
	[[^The breath of (\S+) leaves \S+ in an explosive gasp as the end of the staff smashes home\.]],
	[[^The end of the staff smashes into the exposed throat of (\S+), crushing cartilage\.]],
	[[^(\S+) staggers as the staff cracks across \S+ ribs, sweat breaking out upon \S+ forehead\.]],

	-- Infernal / Oppression
	[[^An agonised expression contorts the face of (\S+)\.]],
	[[^(\S+) lets out a groan as \S+ life is siphoned by the might of Evil\.]],
	[[^(\S+) sags like a puppet with its strings cut, \S+ eyes twitching madly as \S+ stares about in all directions\.]],

	-- Psion / Psionics
	[[^Golden chains of light coalesce in the hands of \S+, and \S+ casts them out to bind (\S+) to \S+\.]],

	-- Psion / Weaving
	[[^\S+ delivers a backhanded blow to the face of (\S+) with a translucent mace\.]],
	[[^Almost too swift to perceive, \S+ lashes out with a translucent dagger, tracing a bloody line across the throat of (\S+)\.]],
	[[^\S+ drives a translucent sword into the guts of (\S+) with a brutal thrust, ripping it free in a spray of crimson\.]],
	[[^\S+ lashes out with lightning speed, \S+ blade driving into (\S+) just beneath \w+ (?:left|right) shoulder\.]],
	[[^\S+ brings a translucent mace around in a savage overhand strike, smashing it into the head of (\S+)\.]],
	[[^\S+ severs the muscles in the (?:left|right) arm of (\S+) with a precise blow of \S+ translucent sword\.]],

	-- Depthswalker / Instills
	[[^Grey fog begins to rise from the suddenly panicked-looking (\S+)\.]],
	[[^A grey miasma flares around (\S+)\.]],
	[[^As the weapon strikes (\S+), \S+ seems greatly diminished\.]],
	[[^As the scythe comes away, the writhing shadow of (\S+) clings to the weapon\.]],
	[[^As the weapon strikes (\S+), it blazes with incandescent white flame\.]],
	[[^The white flame leaps from the scythe to (\S+), blazing with a terrible intensity before guttering out\.]],
	[[^As the weapon strikes (\S+), \S+ face grows vacant and \S+ begins to tremble\.]],
	[[^The head of (\S+) snaps back as if struck and \S+ eyes roll madly\.]],
	[[^As the weapon strikes (\S+), it burns with a sickly yellow glow\.]],
	[[^A look of total despair crosses the face of (\S+)\.]],
	[[^As the weapon strikes (\S+), the contact area begins to rot before your eyes\.]],
	[[^(.+)$]],
	[[The face of (\S+) contorts in pain.]],

	-- Airlord
	[[^The protective shield surrounding (\S+) is blown away by the gale-force winds\.]],
	[[^A howling wind sweeps over (\S+), ripping flesh from bone and leaving \S+ face a bloody ruin\.]],
	[[^The ruined face of (\S+) continues to bleed\.]],
	[[^(\S+) clutches at \S+ throat, eyes bulging as \S+ struggles to draw breath\.]],
	[[^A dazed look crosses the face of (\S+)\.]],
	[[^A zephyr of icy wind rolls over (\S+), leaving \S+ diminished\.]],
	[[^A vacant expression creeps across the features of (\S+)\.]],
	[[^A completely blank expression descends upon (\S+)\.]],

	-- Apostate
	[[^(\S+) doubles over, eyes bulging\.]],

	-- Firelord
	[[^The skin of (\S+) is left sensitive and raw\.]],
	[[^(\S+) convulses, face locked in a rictus of agony\.]]
}

for _, pattern in ipairs(patterns) do
	local line = fill_pattern(pattern)
	send(string.format("echo %s", line))
end
