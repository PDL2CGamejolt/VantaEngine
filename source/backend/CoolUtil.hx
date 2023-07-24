package backend;

import flixel.util.FlxSave;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); //prevent "shared:", "preload:" and other library names on file path
		path = formatted[formatted.length-1];
		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
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
		if(decimals < 1)
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
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0) {
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if(countByColor[key] >= maxCount) {
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
		for (i in min...max) dumbArray.push(i);

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

	inline public static function browserLoad(site:String) {
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
	inline public static function getSavePath(folder:String = 'ShadowMario'):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}
}
