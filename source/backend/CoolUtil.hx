package backend;

import flixel.util.FlxSave;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
#if sys
import sys.io.File;
import sys.FileSystem;
import sys.FileStat;
#end

class CoolUtil
{
	inline public static function txtSplit(path:String)
	{
		return [
			for (i in Assets.getText(path).trim().split('\n'))
				i.trim()
		];
	}

	inline public static function quantize(f:Float, snap:Float)
	{
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); // prevent "shared:", "preload:" and other library names on file path
		path = formatted[formatted.length - 1];
		if (FileSystem.exists(path))
			daList = File.getContent(path);
		#else
		if (Assets.exists(path))
			daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	public static inline function coolerTextFile(path:String, daString:String = ''):String
	{
		return Assets.exists(path) ? daString = Assets.getText(path).trim() : '';
	}

	public static function coolReplace(string:String, sub:String, by:String):String
		return string.split(sub).join(by);

	// Example: "winter-horrorland" to "Winter Horrorland". Used for replays
	public static function coolSongFormatter(song:String):String
	{
		var swag:String = coolReplace(song, '-', ' ');
		var splitSong:Array<String> = swag.split(' ');

		for (i in 0...splitSong.length)
		{
			var firstLetter = splitSong[i].substring(0, 1);
			var coolSong:String = coolReplace(splitSong[i], firstLetter, firstLetter.toUpperCase());
			var splitCoolSong:Array<String> = coolSong.split('');

			coolSong = Std.string(splitCoolSong[0]).toUpperCase();

			for (e in 0...splitCoolSong.length)
				coolSong += Std.string(splitCoolSong[e + 1]).toLowerCase();

			coolSong = coolReplace(coolSong, 'null', '');

			for (l in 0...splitSong.length)
			{
				var stringSong:String = Std.string(splitSong[l + 1]);
				var stringFirstLetter:String = stringSong.substring(0, 1);

				var splitStringSong = stringSong.split('');
				stringSong = Std.string(splitStringSong[0]).toUpperCase();

				for (l in 0...splitStringSong.length)
					stringSong += Std.string(splitStringSong[l + 1]).toLowerCase();

				stringSong = coolReplace(stringSong, 'null', '');

				coolSong += ' $stringSong';
			}

			song = coolSong.replace(' Null', '');
			return song;
		}

		return swag;
	}

	/**
	 * Reads the directory AND all sub-directories aswell and KEEPS THEIR FULL PATHS unless toggled off!
	 * @param path The path you want to read, must be a directory
	 * @param onlyNewFolders If set to true, the old path will be ignored and only new relevant info will be returned.
	 * @return A sorted Array of Strings representing the folders and underneath them their contents
	 */
	public static function readDirectoryFull(path:String, onlyNewFolders:Bool = false):Array<String>
	{
		var content:Array<String> = [];
		var directoryContent:Array<String> = FileSystem.readDirectory(path);

		function folderCheck(file_:String)
		{
			content.push(file_);
			if (FileSystem.isDirectory(file_))
			{
				final subFolder:Array<String> = FileSystem.readDirectory(file_);
				if (subFolder.length > 0)
					for (subFile in subFolder)
					{
						folderCheck('$file_/$subFile');
					}
			}
		}
		for (file in directoryContent)
		{
			folderCheck('$path/$file');
		}
		if (!onlyNewFolders)
			return content;

		var relevantContent:Array<String> = [];
		for (newStuff in content)
		{
			relevantContent.push(newStuff.replace('$path/', ''));
		}
		return relevantContent;
	}
}

#if sys
public static function coolPathArray(path:String):Array<String>
{
	return FileSystem.readDirectory(FileSystem.absolutePath(path));
}
#end

inline public static function colorFromString(color:String):FlxColor
{
	var hideChars = ~/[\t\n\r]/;
	var color:String = hideChars.split(color).join('').trim();
	if (color.startsWith('0x'))
		color = color.substring(color.length - 6);

	var colorNum:Null<FlxColor> = FlxColor.fromString(color);
	if (colorNum == null)
		colorNum = FlxColor.fromString('#$color');
	return colorNum != null ? colorNum : FlxColor.WHITE;
}

inline public static function listFromString(string:String):Array<String>
{
	var daList:Array<String> = [];
	daList = string.trim().split('\n');

	for (i in 0...daList.length)
		daList[i] = daList[i].trim();

	return daList;
}

public static function floorDecimal(value:Float, decimals:Int):Float
{
	if (decimals < 1)
		return Math.floor(value);

	var tempMult:Float = 1;
	for (i in 0...decimals)
		tempMult *= 10;

	var newValue:Float = Math.floor(value * tempMult);
	return newValue / tempMult;
}

inline public static function dominantColor(sprite:flixel.FlxSprite):Int
{
	var countByColor:Map<Int, Int> = [];
	for (col in 0...sprite.frameWidth)
	{
		for (row in 0...sprite.frameHeight)
		{
			var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			if (colorOfThisPixel != 0)
			{
				if (countByColor.exists(colorOfThisPixel))
					countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
				else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					countByColor[colorOfThisPixel] = 1;
			}
		}
	}

	var maxCount = 0;
	var maxKey:Int = 0; // after the loop this will store the max color
	countByColor[FlxColor.BLACK] = 0;
	for (key in countByColor.keys())
	{
		if (countByColor[key] >= maxCount)
		{
			maxCount = countByColor[key];
			maxKey = key;
		}
	}
	countByColor = [];
	return maxKey;
}

inline public static function numberArray(max:Int, ?min = 0):Array<Int>
{
	var dumbArray:Array<Int> = [];
	for (i in min...max)
		dumbArray.push(i);

	return dumbArray;
}

inline public static function clamp(value:Float, min:Float, max:Float):Float
{
	return Math.max(min, Math.min(max, value));
}

/**
	Funny handler for `Application.current.window.alert` that *doesn't* crash on Linux and shit.
	@param message Message of the error.
	@param title Title of the error.
	@author Leather128
**/
public static function coolError(message:Null<String> = null, title:Null<String> = null):Void
{
	#if !linux
	lime.app.Application.current.window.alert(message, title);
	#else
	trace(title + " - " + message, ERROR);
	var text:FlxText = new FlxText(8, 0, 1280, title + " - " + message, 24);
	text.color = FlxColor.RED;
	text.borderSize = 1.5;
	text.borderStyle = OUTLINE;
	text.borderColor = FlxColor.BLACK;
	text.scrollFactor.set();
	text.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	FlxG.state.add(text);

	FlxTween.tween(text, {alpha: 0, y: 8}, 5, {
		onComplete: function(_)
		{
			FlxG.state.remove(text);
			text.destroy();
		}
	});
	#end
}

public static function formatString(string:String):String
{
	var split:Array<String> = string.split('-');
	var formattedString:String = '';
	for (i in 0...split.length)
	{
		var piece:String = split[i];
		var allSplit = piece.split('');
		var firstLetterUpperCased = allSplit[0].toUpperCase();
		var substring = piece.substr(1, piece.length - 1);
		var newPiece = firstLetterUpperCased + substring;
		if (i != split.length - 1)
		{
			newPiece += " ";
		}
		formattedString += newPiece;
	}
	return formattedString;
}

inline public static function browserLoad(site:String)
{
	#if linux
	Sys.command('/usr/bin/xdg-open', [site]);
	#else
	FlxG.openURL(site);
	#end
}

/** Quick Function to Fix Save Files for Flixel 5
	if you are making a mod, you are gonna wanna change "ShadowMario" to something else
	so Base Psych saves won't conflict with yours
	@BeastlyGhost
**/
inline public static function getSavePath(folder:String = 'ShadowMario'):String
{
	@:privateAccess
	return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
		+ '/'
		+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
}

// denpa engine functions idk
inline public static function curveNumber(input:Float = 1, ?curve:Float = 10):Float
{
	return Math.sqrt(input) * curve;
}

/**
 * Removes duplicate instances from the input `Array<String>` and sorts alphabetically.
 * @param string The `Array<String>` to be used.
 */
inline public static function removeDuplicates(string:Array<String>):Array<String>
{
	var tempArray:Array<String> = new Array<String>();
	var lastSeen:String;
	string.sort(function(str1:String, str2:String)
	{
		return (str1 == str2) ? 0 : (str1 > str2) ? 1 : -1;
	});
	for (str in string)
	{
		if (str != lastSeen)
		{
			tempArray.push(str);
		}
		lastSeen = str;
	}
	return tempArray;
}

/**
 * Executes the function in a seperate thread (if one is available), keeping the game from stopping execution until the function finished loading.
 * 
 * Use with caution!
 * @param func The function you want to execute
 * @param funcTwo Function to be executed if no thread is available (Will be executed on the main thread)
 * @param forceExecution If true, `func` will be executed even if no thread was available (however on the main thread).
 * Will load `funcTwo` aswell if it is not set to `null`!
 * @return True if a thread was available, False if no thread was available or on browser-targets
 */
public static function loadThreaded(func:Void->Void, ?funcTwo:Void->Void = null, forceExecution:Bool = false):Bool
{
	#if (target.threaded && sys)
	Main.threadPool.run(() ->
	{
		func();
	});

	return true;
	#end
	if (forceExecution)
		func();
	if (funcTwo != null)
		funcTwo();

	return false;
}

// shit below is for Debug class, but I'm sure you can use it elsewhere

/**
 * Gets any variable from Class defined by "daClass", can be used outside of Lua.
 * @param daClass The class to get the variable from
 * @param daField The variable inside that class as a string
 * @param returnString Whetever to force the output to be a string or not. If false will return value of its own class type.
 */
public static function getObjectFromClass(daClass:Dynamic, daField:String, returnString:Bool = false):Dynamic
{
	// for each property seperated by a "." (like object.innerBox.x) make different variables to "reflect"
	var variableSplit:Array<String> = daField.split('.');

	if (variableSplit.length > 1)
	{
		var mainVariable:Dynamic = Reflect.getProperty(daClass, variableSplit[0]);

		for (property in 1...variableSplit.length - 1)
		{
			mainVariable = Reflect.getProperty(mainVariable, variableSplit[property]);
		}
		if (returnString)
			return Std.string(Reflect.getProperty(mainVariable, variableSplit[variableSplit.length - 1]));
		return Reflect.getProperty(mainVariable, variableSplit[variableSplit.length - 1]);
	}
	if (returnString)
		return Std.string(Reflect.getProperty(daClass, daField)); // If there is only one property return the variable value
	return Reflect.getProperty(daClass, daField);
}

/**
 * Gets variable the same way "reflectObjectFromClass" does, then changes the variable property to "value" (can be any type)
 * @param daClass The class to get the variable from
 * @param daField The variable inside that class as a string
 * @param value The new value for that variable
 */
public static function setObjectFromClass(daClass:Dynamic, daField:String, value:Dynamic)
{
	var variableSplit:Array<String> = daField.split('.');

	if (variableSplit.length > 1)
	{
		var mainVariable:Dynamic = Reflect.getProperty(daClass, variableSplit[0]);

		for (property in 1...variableSplit.length - 1)
		{
			mainVariable = Reflect.getProperty(mainVariable, variableSplit[property]);
		}
		return Reflect.setProperty(mainVariable, variableSplit[variableSplit.length - 1], value);
	}
	return Reflect.setProperty(daClass, daField, value);
}

/**
 * Returns an `FlxEase` type based on the input `String`.
 * @param ease The easing `String` to use.
 */
public static function easeFromString(?ease:String = '')
{
	switch (ease.toLowerCase().trim())
	{
		case 'backin':
			return FlxEase.backIn;
		case 'backinout':
			return FlxEase.backInOut;
		case 'backout':
			return FlxEase.backOut;
		case 'bouncein':
			return FlxEase.bounceIn;
		case 'bounceinout':
			return FlxEase.bounceInOut;
		case 'bounceout':
			return FlxEase.bounceOut;
		case 'circin':
			return FlxEase.circIn;
		case 'circinout':
			return FlxEase.circInOut;
		case 'circout':
			return FlxEase.circOut;
		case 'cubein':
			return FlxEase.cubeIn;
		case 'cubeinout':
			return FlxEase.cubeInOut;
		case 'cubeout':
			return FlxEase.cubeOut;
		case 'elasticin':
			return FlxEase.elasticIn;
		case 'elasticinout':
			return FlxEase.elasticInOut;
		case 'elasticout':
			return FlxEase.elasticOut;
		case 'expoin':
			return FlxEase.expoIn;
		case 'expoinout':
			return FlxEase.expoInOut;
		case 'expoout':
			return FlxEase.expoOut;
		case 'quadin':
			return FlxEase.quadIn;
		case 'quadinout':
			return FlxEase.quadInOut;
		case 'quadout':
			return FlxEase.quadOut;
		case 'quartin':
			return FlxEase.quartIn;
		case 'quartinout':
			return FlxEase.quartInOut;
		case 'quartout':
			return FlxEase.quartOut;
		case 'quintin':
			return FlxEase.quintIn;
		case 'quintinout':
			return FlxEase.quintInOut;
		case 'quintout':
			return FlxEase.quintOut;
		case 'sinein':
			return FlxEase.sineIn;
		case 'sineinout':
			return FlxEase.sineInOut;
		case 'sineout':
			return FlxEase.sineOut;
		case 'smoothstepin':
			return FlxEase.smoothStepIn;
		case 'smoothstepinout':
			return FlxEase.smoothStepInOut;
		case 'smoothstepout':
			return FlxEase.smoothStepInOut;
		case 'smootherstepin':
			return FlxEase.smootherStepIn;
		case 'smootherstepinout':
			return FlxEase.smootherStepInOut;
		case 'smootherstepout':
			return FlxEase.smootherStepOut;
	}
	return FlxEase.linear;
}

/**
 * Returns a `BlendMode` based on the input `String`.
 * @param blend The blend `String` to use.
 */
public static function blendFromString(blend:String):BlendMode
{
	switch (blend.toLowerCase().trim())
	{
		case 'add':
			return ADD;
		case 'alpha':
			return ALPHA;
		case 'darken':
			return DARKEN;
		case 'difference':
			return DIFFERENCE;
		case 'erase':
			return ERASE;
		case 'hardlight':
			return HARDLIGHT;
		case 'invert':
			return INVERT;
		case 'layer':
			return LAYER;
		case 'lighten':
			return LIGHTEN;
		case 'multiply':
			return MULTIPLY;
		case 'overlay':
			return OVERLAY;
		case 'screen':
			return SCREEN;
		case 'shader':
			return SHADER;
		case 'subtract':
			return SUBTRACT;
	}
	return NORMAL;
}

// yea im just lazy, might as well rewrite them later
}
