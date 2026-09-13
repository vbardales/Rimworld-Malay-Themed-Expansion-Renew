const fs=require('fs'),path=require('path'),http=require('http');
const {chromium}=require('playwright');
(async()=>{
 const root=__dirname;
 const server=http.createServer((req,res)=>{let name=decodeURIComponent(req.url.split('?')[0]);if(name==='/')name='/preview.html';const file=path.resolve(root,'.'+name);if(!file.startsWith(root+path.sep)){res.writeHead(403);return res.end()}fs.readFile(file,(err,data)=>{if(err){res.writeHead(404);return res.end()}res.setHeader('Content-Type',file.endsWith('.png')?'image/png':file.endsWith('.json')?'application/json':'text/html');res.end(data)})}).listen(0,'127.0.0.1');
 await new Promise(r=>server.once('listening',r));
 const browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 try{
 const page=await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
 await page.goto('http://127.0.0.1:'+server.address().port);
 await page.evaluate(()=>window.ready);
 const font=await page.evaluate(()=>({available:document.fonts.check('46px "Segoe UI"'),family:getComputedStyle(document.querySelector('h1')).fontFamily}));
 if(!font.available)throw Error('Segoe UI is not available');
 const archive=path.join(root,'Preview-before-renew.png');if(!fs.existsSync(archive))fs.copyFileSync(path.join(root,'../Mod/About/Preview.png'),archive);
 await page.screenshot({path:path.join(root,'../Mod/About/Preview.png')});
 const rects=await page.evaluate(()=>Object.fromEntries(['h1','h1 span','p','#version'].map(s=>{let e=document.querySelector(s),r=e.getBoundingClientRect();return[s,{x:r.x,y:r.y,width:r.width,height:r.height,color:getComputedStyle(e).color}]})));
 await page.addStyleTag({content:'h1,p,#version{visibility:hidden}'});
 await page.screenshot({path:path.join(root,'Preview-background-qa.png')});
 fs.writeFileSync(path.join(root,'preview-layout-qa.json'),JSON.stringify({font,rects},null,2));
 }finally{await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exit(1)});
