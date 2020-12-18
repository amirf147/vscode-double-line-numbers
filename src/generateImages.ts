const fs = require('fs');
const TextToSVG = require('text-to-svg');
const sharp = require('sharp');

const FONT = 72; 
const SIZE = 30;
export const OUT_DIR = __dirname + "/images/";  // must end with /

const textToSVG = TextToSVG.loadSync();
const attributes = {fill: 'gray', stroke: 'gray'};
const options = {x: 0, y: FONT/2, fontSize: FONT, anchor: 'left middle', attributes: attributes};

if (!fs.existsSync(OUT_DIR)){
    fs.mkdirSync(OUT_DIR);
}

export function generateImages(start : number, end : number) {
    // console.log("generateImages START" + start + " " + end)
    
    for(var i = start; i < end; ++i) {
        var name = i.toString()
        var content = i.toString()
        if(i == 0) content = ' '

        const svg = textToSVG.getSVG(content, options);
        fs.writeFileSync(OUT_DIR + name + ".svg", svg);
        
        sharp(OUT_DIR + name + ".svg")
        .resize(SIZE, SIZE, {
            fit: 'contain',
            background: { r: 255, g: 255, b: 255, alpha: 0 }
        })
        .toFile(OUT_DIR + name + ".png", () => { })

        // fs.unlinkSync(OUT_DIR + i.toString() + ".svg"); 
    }
    // console.log("generateImages END" + start + " " + end)
}