import nbtd;

unittest
{
	NBTCompound level = new NBTCompound();
	level.name = "Level";
	level["players"] = new NBTList([new NBTString("Foo"), new NBTString("Bar")]);
	level["seed"] = new NBTLong(48968643157);

	NBTCompound imported = new NBTCompound();
	imported.decode(level.encode());
	assert(imported.name == "Level");
	assert(imported["players"].asList().length == 2);
	assert(imported["players"].asList()[0].asString().value == "Foo");
	assert(imported["players"].asList()[1].asString().value == "Bar");
	assert(imported["seed"].asLong().value == 48968643157);
}
