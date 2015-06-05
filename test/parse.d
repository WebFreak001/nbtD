import nbtd;

import std.bitmanip;

unittest
{
	INBTItem nbtItem = parseNBT(cast(ubyte[])[1, 0, 0, 5], false);
	assert(nbtItem.type == NBTType.Byte);
	NBTByte nbtByte = cast(NBTByte)nbtItem;
	assert(nbtByte.name == "");
	assert(nbtByte.value == 5);

	INBTItem nbtStrItem = parseNBT(cast(ubyte[])[8, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(short)11) ~ cast(ubyte[])"Hello World", false);
	assert(nbtStrItem.type == NBTType.String);
	NBTString nbtText = cast(NBTString)nbtStrItem;
	assert(nbtText.name == "");
	assert(nbtText.value == "Hello World");
}
