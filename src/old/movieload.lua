
--pcsx.switchspu("spuTAS.dll");
--movie.stop()
emu=pcsx;
print("vvv")

movie.load("BB2 slash mode 6443 dammit.pxm")

--movie.load("suiko2.pxm")

print("dd")
pcsx.testgpu();
print("ee")
pcsx.frameadvance();
print("ff")
	print("gg")

while true do
	print(pcsx.framecount());
	pcsx.frameadvance();
end