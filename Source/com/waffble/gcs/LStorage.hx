package com.waffble.gcs;

/**
 * ...
 * @author Ben Lanier
 */

extern class LStorage {
	
	public function new():Void;
	public function load(key:String):String;
	public function store(key:String, value:String):String;
	
}