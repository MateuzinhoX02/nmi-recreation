function onCreate()
	-- background shit
    makeLuaSprite('preto', 'backgrounds/innocence_bg_1', -560, -300);
	setScrollFactor('preto', 1.2, 1.2);
    scaleObject('preto', 1.1, 1.1);
    addLuaSprite('preto', false)

    makeLuaSprite('chaum', 'backgrounds/Ilustracion8', -650, 600);
	setScrollFactor('chaum', 0.9, 0.9);
	scaleObject('chaum', 1.1, 1.1);
    addLuaSprite('chaum', false)

    makeLuaSprite('chaum2', 'backgrounds/Floor', -650, 600);
	setScrollFactor('chaum2', 0.9, 0.9);
	scaleObject('chaum2', 1.1, 1.1);
    addLuaSprite('chaum', false)


end
