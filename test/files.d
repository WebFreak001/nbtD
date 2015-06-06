import nbtd;

import std.file;

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
	assert(bigTest.name == "Level");
	assert(bigTest["byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"].asByteArray()[0] == 0);
	assert(bigTest["byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"].asByteArray()[1] == 62);
	assert(bigTest["byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"].asByteArray()[2] == 34);
	assert(bigTest["byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"].asByteArray()[3] == 16);
	assert(bigTest["byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"].asByteArray().length == 1000);
	assert(bigTest["byteTest"].asByte().value == 127);
	assert(bigTest["intTest"].asInt().value == 2147483647);
	assert(bigTest["listTest (compound)"].asList().length == 2);
	assert(bigTest["listTest (compound)"].asList()[0].asCompound()["created-on"].asLong().value == 1264099775885);
	assert(bigTest["listTest (long)"].asList().length == 5);
	assert(bigTest["longTest"].asLong().value == 9223372036854775807);
	assert(bigTest["nested compound test"].asCompound()["egg"].asCompound()["name"].asString().value == "Eggbert");
	assert(bigTest["shortTest"].asShort().value == 32767);
	assert(bigTest["stringTest"].asString().value == "HELLO WORLD THIS IS A TEST STRING \xc3\x85\xc3\x84\xc3\x96!");

	NBTCompound level = new NBTCompound();
	level.decode(cast(ubyte[])read("test/level.dat"), true);
	assert(level.value.length == 1);
	assert(level["Data"].type == NBTType.Compound);
	auto data = cast(NBTCompound)level["Data"];
	assert(data["DayTime"].asLong().value == 34833043L);
	assert(data["GameType"].asInt().value == 0);
	assert(data["GameRules"].asCompound().get!NBTString("commandBlockOutput").value == "true");
	assert(data["LevelName"].asString().value == "MainSpawn");
	assert(data["MapFeatures"].asByte().value == 1);
}
