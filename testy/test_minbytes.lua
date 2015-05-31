local minbytes = require("bitutils").minbytes;

print(minbytes(0));
print(minbytes(0x1ff));
print(minbytes(0x01ffff));
print(minbytes(0x0100ffff));
print(minbytes(0xffffffffffff));

exit();
