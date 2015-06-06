import nbtd;

import std.file;
import std.zlib;

unittest
{
	NBTCompound helloWorld = new NBTCompound();
	helloWorld.decode(cast(ubyte[])read("test/hello_world.nbt"), false);

	assert(helloWorld.name == "hello world");
	assert(helloWorld.value.length == 1);
	assert(helloWorld.value[0].type == NBTType.String);
	assert(helloWorld.get!NBTString("name").value == "Bananrama");

	NBTCompound bigTest = new NBTCompound();
	bigTest.decode(cast(ubyte[])read("test/bigtest.nbt"), true);

	NBTCompound level = new NBTCompound();
	level.decode(cast(ubyte[])read("test/level.dat"), true);
}
