// Written by Valentina Boichuk

/*
@@@BUILDINFO@@@ Scale_to_target.jsx 1.0.0.1
*/

/*

// BEGIN__HARVEST_EXCEPTION_ZSTRING

<javascriptresource>
<name>$$$/JavaScripts/ScaleToTarget/Menu=Scale to target (1024x600)</name>
<category>Scale</category>
<enableinfo>true</enableinfo>
</javascriptresource>

// END__HARVEST_EXCEPTION_ZSTRING

*/

/*
var psdOpts = new PhotoshopSaveOptions();
psdOpts.embedColorProfile = true;
psdOpts.alphaChannels = true;
psdOpts.layers = true;
psdOpts.spotColors = true;
*/

var jpgSaveOptions = new JPEGSaveOptions();  
jpgSaveOptions.embedColorProfile = true;  
jpgSaveOptions.formatOptions = FormatOptions.STANDARDBASELINE;  
jpgSaveOptions.matte = MatteType.NONE;  
jpgSaveOptions.quality = 9;   

app.preferences.rulerUnits = Units.PIXELS;

var docs = app.documents;
while (app.documents.length > 0) {

	app.activeDocument = docs[0];
	doc = app.activeDocument; 

	var bounds = new Array(0, 0, doc.width, doc.height);
	doc.crop(bounds);

	doc.changeMode(ChangeMode.RGB); 

	var fWidth = 1024;
	var fHeight = 600;

	if (doc.width < doc.height)
	{
		if (doc.height > fHeight)
			doc.resizeImage(null, UnitValue(fHeight,"px"), null, ResampleMethod.BICUBICSHARPER);
	}
	else
	{
		if (doc.width > fWidth)
			doc.resizeImage(UnitValue(fWidth,"px"), null, null, ResampleMethod.BICUBICSHARPER);
	}

	var directory = Folder(doc.path + "/small");
	if (!directory.exists)
		directory.create();

	var saveFile = new File(directory + "/" + doc.name)

	doc.saveAs(saveFile, jpgSaveOptions, true, Extension.LOWERCASE);  

	doc.close(SaveOptions.DONOTSAVECHANGES)
}


