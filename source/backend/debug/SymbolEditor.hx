package backend.debug;

class SymbolEditor extends AState {
    public var menuBar:AMenuBar;
    public var footerBar:AMenuBar;
    public function new() {
        super();
        trace("Editor launched");
        Main.addKeyPressed("SymbolGeneratorExitKey", Keyboard.ESCAPE, true, (_:KeyboardEvent)->{
            Main.StateSystem.switchState(InitState);
        });

        try{
            menuBar = new AMenuBar(TOP, [
                {
                    type: ACHECKBOX,
                    text: "snap to grid",
                    enabled: true,
                    onClick: (_:Bool)->{
                        trace('Grid should show? $_');
                    }
                },
                {
                    type: ACHECKBOX,
                    text: "show grid",
                    enabled: true,
                    onClick: (_:Bool)->{
                        trace('Snap to grid? $_');
                    }
                },
                {type: ASPRITE, /*seperator*/text: "seperator0", size: new APoint(2, 20), color: AColor.MENUBAR_DROPDOWN_BACKGROUND},
                { //index 3
                    type: ATEXT,
                    text: "100%",
                    size: new APoint(35, 0) //y isnt used. and if defaulting worked correctly this wouldnt be needed here. thanks haxe.
                },
                {
                    type: ABUTTON,
                    size: new APoint(75, 20),
                    text: "Reset view",
                    onClick: (_:AButton)->{
                        trace('Attempting to reset view...');
                    }
                },
                {type: ASPRITE, /*seperator*/text: "seperator0", size: new APoint(2, 20), color: AColor.MENUBAR_DROPDOWN_BACKGROUND},
                {
                    type: ABUTTON,
                    text: "Undo",
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{
                        trace('Attempting to undo last change...');
                    }
                },
                {
                    type: ABUTTON,
                    size: new APoint(50, 20),
                    text: "Clear all",
                    onClick: (_:AButton)->{
                        trace('Attempting to clear all changes...');
                    }
                },
            ]);
            add(menuBar);

            var tabMenu:ATabMenu = new ATabMenu(Main.pWidth-400, 0, new APoint(400, Main.pHeight));
            add(tabMenu);

            var testGroup1:AGroup<ASprite> = new AGroup<ASprite>(0, 0);
                testGroup1.addChild(new AText(0, 0, 100, "group 1!", 12));
                
            /*Style group section*/
            var styleGroup:AGroup<ASprite> = new AGroup<ASprite>(0, 0);
                styleGroup.addChild(new AText(5, 5, 100, "FILL", 12));
                styleGroup.addChild(new ACheckBox(5, 25, "Enabled", (_:Bool)->{
                    trace('Enabled fill color? $_');
                }));
                //styleGroup.addChild(new AText(0, 0, 100, "FILL", 12));

            var testGroup3:AGroup<ASprite> = new AGroup<ASprite>(0, 0);
                testGroup3.addChild(new AText(0, 0, 100, "group 3!", 12));

            tabMenu.addGroup("first", testGroup1);
            tabMenu.addGroup("Style", styleGroup);
            tabMenu.addGroup("third", testGroup3);






            footerBar = new AMenuBar(BOTTOM, [
                {
                    text: "click: MOVE · drag: LINE · right-drag: move point · wheel: zoom · middle-drag: pan",
                    type: ATEXT,
                    size: new APoint(410, 0),
                    color: AColor.MENUBAR_DROPDOWN_BACKGROUND
                },
                {type: ASPRITE, text: "seperator_footer", size: new APoint(2, 20), color: AColor.MENUBAR_DROPDOWN_BACKGROUND},
                {
                    text: "x: {X}, y: {Y}",
                    type: ATEXT,
                    size: new APoint(420, 18),
                    color: AColor.MENUBAR_DROPDOWN_BACKGROUND
                }
            ]);
            add(footerBar);
        }catch(e){
            trace('Something went wrong! ${e.stack}');
        }
    }

    override public function destroy() {
        super.destroy();
    }
}

//  <aside>
//    <div class="tabs">
//      <button class="tab-btn active" data-tab="commands">Commands</button>
//      <button class="tab-btn" data-tab="style">Style</button>
//      <button class="tab-btn" data-tab="code">Export / Import</button>
//    </div>
//
//    <div class="tabpane active" id="tab-commands">
//      <p class="section-title">Command sequence</p>
//      <div id="cmdList"></div>
//      <div class="small-note">Click the canvas to append a MOVE, click-and-drag to append a LINE, or edit x/y directly here. Right-drag moves an existing point; middle-drag pans; scroll to zoom.</div>
//    </div>
//
//    <div class="tabpane" id="tab-style">
//      <p class="section-title">Fill</p>
//      <div class="field-row"><label>enabled</label><input type="checkbox" id="fillEnabled" checked></div>
//      <div class="field-row"><label>color</label><input type="color" id="fillColor" value="#5fd0c0"><input type="text" id="fillColorHex" value="0x5FD0C0" style="font-family:'JetBrains Mono',monospace;"></div>
//      <div class="field-row"><label>alpha</label><input type="range" id="fillAlpha" min="0" max="1" step="0.01" value="1"><span class="val" id="fillAlphaVal">1.00</span></div>
//
//      <div class="divider"></div>
//      <p class="section-title">Outline (thickness / outlineColor)</p>
//      <div class="field-row"><label>enabled</label><input type="checkbox" id="strokeEnabled"></div>
//      <div class="field-row"><label>color</label><input type="color" id="strokeColor" value="#e0e6f0"><input type="text" id="strokeColorHex" value="0xE0E6F0" style="font-family:'JetBrains Mono',monospace;"></div>
//      <div class="field-row"><label>alpha</label><input type="range" id="strokeAlpha" min="0" max="1" step="0.01" value="1"><span class="val" id="strokeAlphaVal">1.00</span></div>
//      <div class="field-row"><label>thickness</label><input type="number" id="strokeThickness" value="1" min="0" max="20"></div>
//
//      <div class="divider"></div>
//      <p class="section-title">Icon meta</p>
//      <div class="field-row"><label>icon name</label><input type="text" id="iconName" value="mute"></div>
//    </div>
//
//    <div class="tabpane" id="tab-code">
//      <p class="section-title">Generated ADrawableIcons entry</p>
//      <textarea id="exportCode" readonly></textarea>
//      <div class="copybar">
//        <button id="copyBtn" class="primary">Copy</button>
//      </div>
//      <div class="divider"></div>
//      <p class="section-title">Import existing command array</p>
//      <textarea id="importCode" placeholder="Paste an ADrawableIconCommand array, e.g.&#10;[&#10;  {t:MOVE,a:{x:0,y:0}},&#10;  {t:LINE,a:{x:10,y:10}}&#10;]"></textarea>
//      <div class="copybar">
//        <button id="importBtn" class="primary">Parse & load</button>
//      </div>
//      <div class="small-note" id="importMsg"></div>
//    </div>
//  </aside>
//</main>
//
//<footer>Coordinates map 1:1 to OpenFL stage units (y grows downward), same as <code>graphics.moveTo/lineTo</code>.</footer>
//
//<script>
//(function(){
//  const canvas = document.getElementById('stage');
//  const ctx = canvas.getContext('2d');
//  const holder = document.getElementById('stage-holder');
//  const coordHint = document.getElementById('coordHint');
//
//  let commands = []; // {t:'MOVE'|'LINE', x, y}
//  let px = 16; // pixels per unit (zoom)
//  let snap = true;
//  let dragIndex = -1;   // index of a point being moved via right-drag
//  let history = [];
//
//  let originX = 40, originY = 40; // px offset for origin within canvas - mutable, panned by middle-drag
//
//  // left-click drag-to-draw state
//  let drawing = false;
//  let drawStartWorld = null;   // [x,y] where the left button went down
//  let drawStartScreen = null;  // raw screen px, to tell a click from a drag
//  let previewEnd = null;       // [x,y] live drag endpoint, for the rubber-band preview
//
//  // middle-click pan state
//  let panning = false;
//  let panStartScreen = null;
//  let panStartOrigin = null;
//
//  const CLICK_THRESHOLD_PX = 5; // movement under this = a click, not a drag
//  const MIN_PX = 0.5, MAX_PX = 4000; // effectively infinite zoom range
//
//  function pushHistory(){
//    history.push(JSON.stringify(commands));
//    if(history.length > 60) history.shift();
//  }
//  function undo(){
//    if(history.length){
//      commands = JSON.parse(history.pop());
//      renderAll();
//    }
//  }
//
//  function toScreen(x,y){ return [originX + x*px, originY + y*px]; }
//
//  function drawGrid(){
//    // pick a "nice" world-unit step so lines never get overwhelmingly dense or sparse,
//    // however far zoomed in/out (1, 2, 5, 10, 20, 50 ... pattern)
//    const targetPx = 28; // aim for roughly this many screen px between lines
//    const rawStep = targetPx / px;
//    const mag = Math.pow(10, Math.floor(Math.log10(rawStep)));
//    const norm = rawStep / mag;
//    const niceNorm = norm < 1.5 ? 1 : norm < 3.5 ? 2 : norm < 7.5 ? 5 : 10;
//    const step = niceNorm * mag;
//    const majorEvery = 5; // every 5th line drawn brighter, as a sub-grid landmark
//
//    const worldLeft   = (0 - originX) / px;
//    const worldRight  = (canvas.width - originX) / px;
//    const worldTop    = (0 - originY) / px;
//    const worldBottom = (canvas.height - originY) / px;
//
//    const startI = Math.floor(worldLeft / step);
//    const endI   = Math.ceil(worldRight / step);
//    const startJ = Math.floor(worldTop / step);
//    const endJ   = Math.ceil(worldBottom / step);
//
//    ctx.save();
//    ctx.lineWidth = 1;
//    ctx.font = '9px JetBrains Mono, monospace';
//
//    for(let i = startI; i <= endI; i++){
//      const wx = i * step;
//      const [sx] = toScreen(wx, 0);
//      const isMajor = i % majorEvery === 0;
//      ctx.strokeStyle = isMajor ? '#2c3342' : '#1e232d';
//      ctx.beginPath();
//      ctx.moveTo(sx, 0); ctx.lineTo(sx, canvas.height);
//      ctx.stroke();
//      if(isMajor && wx !== 0){
//        ctx.fillStyle = '#4a5266';
//        ctx.fillText(fmt(wx), sx + 3, 11);
//      }
//    }
//    for(let j = startJ; j <= endJ; j++){
//      const wy = j * step;
//      const [,sy] = toScreen(0, wy);
//      const isMajor = j % majorEvery === 0;
//      ctx.strokeStyle = isMajor ? '#2c3342' : '#1e232d';
//      ctx.beginPath();
//      ctx.moveTo(0, sy); ctx.lineTo(canvas.width, sy);
//      ctx.stroke();
//      if(isMajor && wy !== 0){
//        ctx.fillStyle = '#4a5266';
//        ctx.fillText(fmt(wy), 3, sy - 3);
//      }
//    }
//    ctx.restore();
//  }
//  function toWorld(sx,sy,applySnap=true){
//    let x = (sx - originX)/px, y = (sy - originY)/px;
//    if(applySnap && snap){ x = Math.round(x); y = Math.round(y); }
//    return [x,y];
//  }
//  function updateZoomReadout(){
//    document.getElementById('zoomReadout').textContent = Math.round(px/16*100) + '%';
//  }
//
//  function hexToRgb(hex){
//    hex = hex.replace('#','').replace('0x','').replace('0X','');
//    const n = parseInt(hex,16);
//    return [(n>>16)&255, (n>>8)&255, n&255];
//  }
//  function colorInputToHaxeHex(colorPicker){
//    return '0x' + colorPicker.value.replace('#','').toUpperCase();
//  }
//
//  function draw(){
//    ctx.clearRect(0,0,canvas.width,canvas.height);
//
//    if(document.getElementById('showGrid').checked){
//      drawGrid();
//    }
//
//    // axes
//    ctx.strokeStyle = '#3a4152';
//    ctx.lineWidth = 1.5;
//    ctx.beginPath();
//    ctx.moveTo(originX, 0); ctx.lineTo(originX, canvas.height);
//    ctx.moveTo(0, originY); ctx.lineTo(canvas.width, originY);
//    ctx.stroke();
//
//    if(commands.length){
//      const fillEnabled = document.getElementById('fillEnabled').checked;
//      const fillAlpha = parseFloat(document.getElementById('fillAlpha').value);
//      const fillColor = document.getElementById('fillColor').value;
//      const strokeEnabled = document.getElementById('strokeEnabled').checked;
//      const strokeAlpha = parseFloat(document.getElementById('strokeAlpha').value);
//      const strokeColor = document.getElementById('strokeColor').value;
//      const thickness = parseFloat(document.getElementById('strokeThickness').value) || 1;
//
//      ctx.beginPath();
//      let started = false;
//      for(const c of commands){
//        const [sx,sy] = toScreen(c.x, c.y);
//        if(c.t === 'MOVE'){ ctx.moveTo(sx,sy); started = true; }
//        else { if(!started){ ctx.moveTo(sx,sy); started = true; } else ctx.lineTo(sx,sy); }
//      }
//      if(fillEnabled){
//        ctx.fillStyle = fillColor; ctx.globalAlpha = fillAlpha;
//        ctx.fill();
//        ctx.globalAlpha = 1;
//      }
//      if(strokeEnabled){
//        ctx.strokeStyle = strokeColor; ctx.globalAlpha = strokeAlpha; ctx.lineWidth = thickness;
//        ctx.stroke();
//        ctx.globalAlpha = 1;
//      }
//    }
//
//    // points + order
//    commands.forEach((c,i)=>{
//      const [sx,sy] = toScreen(c.x,c.y);
//      ctx.beginPath();
//      ctx.arc(sx,sy, i===dragIndex?6:5, 0, Math.PI*2);
//      ctx.fillStyle = c.t==='MOVE' ? '#e8a33d' : '#5fa8e8';
//      ctx.fill();
//      ctx.strokeStyle = '#0d1015'; ctx.lineWidth = 1.5; ctx.stroke();
//      ctx.fillStyle = '#c9d3e0';
//      ctx.font = '10px JetBrains Mono, monospace';
//      ctx.fillText(i, sx+7, sy-6);
//    });
//
//    // live preview while dragging out a new LINE
//    if(drawing && drawStartWorld && previewEnd){
//      const [sx1,sy1] = toScreen(drawStartWorld[0], drawStartWorld[1]);
//      const [sx2,sy2] = toScreen(previewEnd[0], previewEnd[1]);
//      ctx.save();
//      ctx.setLineDash([4,4]);
//      ctx.strokeStyle = '#5fa8e8';
//      ctx.lineWidth = 1.5;
//      ctx.beginPath();
//      ctx.moveTo(sx1,sy1);
//      ctx.lineTo(sx2,sy2);
//      ctx.stroke();
//      ctx.restore();
//    }
//  }
//
//  function renderList(){
//    const list = document.getElementById('cmdList');
//    if(!commands.length){
//      list.innerHTML = '<div class="empty-note">No commands yet. Pick MOVE or LINE above, then click on the canvas.</div>';
//      return;
//    }
//    list.innerHTML = '';
//    commands.forEach((c,i)=>{
//      const row = document.createElement('div');
//      row.className = 'cmd-row';
//      row.innerHTML = `
//        <span class="idx">#${i}</span>
//        <select class="${c.t}" data-i="${i}" data-f="t">
//          <option value="MOVE" ${c.t==='MOVE'?'selected':''}>MOVE</option>
//          <option value="LINE" ${c.t==='LINE'?'selected':''}>LINE</option>
//        </select>
//        <input type="number" value="${c.x}" data-i="${i}" data-f="x">
//        <input type="number" value="${c.y}" data-i="${i}" data-f="y">
//        <button class="del" data-i="${i}" title="delete">✕</button>
//      `;
//      list.appendChild(row);
//    });
//    list.querySelectorAll('select,input[type=number]').forEach(el=>{
//      el.addEventListener('change', e=>{
//        pushHistory();
//        const i = +e.target.dataset.i, f = e.target.dataset.f;
//        commands[i][f] = f==='t' ? e.target.value : parseFloat(e.target.value)||0;
//        renderAll();
//      });
//    });
//    list.querySelectorAll('.del').forEach(el=>{
//      el.addEventListener('click', e=>{
//        pushHistory();
//        commands.splice(+e.target.dataset.i, 1);
//        renderAll();
//      });
//    });
//  }
//
//  function generateCode(){
//    const iconName = document.getElementById('iconName').value.trim() || 'myIcon';
//    const lines = commands.map(c=>`        {t:${c.t}, a:{x:${fmt(c.x)}, y:${fmt(c.y)}}},`).join('\n');
//    const fillColor = colorInputToHaxeHex(document.getElementById('fillColor'));
//    const fillAlpha = document.getElementById('fillAlpha').value;
//    const strokeEnabled = document.getElementById('strokeEnabled').checked;
//    const strokeColor = colorInputToHaxeHex(document.getElementById('strokeColor'));
//    const strokeAlpha = document.getElementById('strokeAlpha').value;
//    const thickness = document.getElementById('strokeThickness').value;
//
//    let out = `// Add to ADrawableIcons:\npublic static final ${iconName}:Array<ADrawableIconCommand> = [\n${lines || '        // no commands yet'}\n];\n\n`;
//    out += `// Usage:\nDrawUtil.drawIcon(spr, "${iconName}", ${strokeEnabled?thickness:0}, new AColor(${strokeColor}, ${strokeEnabled?strokeAlpha:0}), new AColor(${fillColor}, ${fillAlpha}));`;
//    document.getElementById('exportCode').value = out;
//  }
//  function fmt(n){ return Number.isInteger(n) ? n : Math.round(n*100)/100; }
//
//  function renderAll(){
//    draw();
//    renderList();
//    generateCode();
//  }
//
//  // --- canvas interaction ---
//  function getMousePos(e){
//    const r = canvas.getBoundingClientRect();
//    const scaleX = canvas.width / r.width, scaleY = canvas.height / r.height;
//    return [(e.clientX - r.left) * scaleX, (e.clientY - r.top) * scaleY];
//  }
//
//  function nearestPointIndex(sx, sy, threshold=12){
//    let closest = -1, closestDist = threshold;
//    commands.forEach((c,i)=>{
//      const [px_,py_] = toScreen(c.x,c.y);
//      const d = Math.hypot(px_-sx, py_-sy);
//      if(d < closestDist){ closest = i; closestDist = d; }
//    });
//    return closest;
//  }
//
//  // right-click's default context menu would otherwise block right-drag
//  canvas.addEventListener('contextmenu', e=> e.preventDefault());
//
//  canvas.addEventListener('mousemove', e=>{
//    const [sx,sy] = getMousePos(e);
//    const [wx,wy] = toWorld(sx,sy);
//    coordHint.textContent = `x: ${wx}, y: ${wy}`;
//
//    if(panning){
//      const dx = sx - panStartScreen[0], dy = sy - panStartScreen[1];
//      originX = panStartOrigin[0] + dx;
//      originY = panStartOrigin[1] + dy;
//      draw();
//      return;
//    }
//    if(dragIndex >= 0){
//      commands[dragIndex].x = wx; commands[dragIndex].y = wy;
//      renderAll();
//      return;
//    }
//    if(drawing){
//      previewEnd = [wx, wy];
//      draw();
//    }
//  });
//
//  canvas.addEventListener('mousedown', e=>{
//    const [sx,sy] = getMousePos(e);
//
//    if(e.button === 1){ // middle click: pan
//      e.preventDefault();
//      panning = true;
//      panStartScreen = [sx,sy];
//      panStartOrigin = [originX, originY];
//      canvas.style.cursor = 'grabbing';
//      return;
//    }
//
//    if(e.button === 2){ // right click: move an existing point, no matter what
//      const idx = nearestPointIndex(sx, sy);
//      if(idx >= 0){ pushHistory(); dragIndex = idx; }
//      return;
//    }
//
//    if(e.button === 0){ // left click: start of a click-or-drag draw gesture
//      const [wx,wy] = toWorld(sx,sy);
//      drawing = true;
//      drawStartWorld = [wx,wy];
//      drawStartScreen = [sx,sy];
//      previewEnd = [wx,wy];
//    }
//  });
//
//  canvas.addEventListener('mouseup', e=>{
//    if(panning){ panning = false; canvas.style.cursor = 'crosshair'; return; }
//    if(dragIndex >= 0){ dragIndex = -1; return; }
//
//    if(drawing){
//      const [sx,sy] = getMousePos(e);
//      const movedPx = Math.hypot(sx - drawStartScreen[0], sy - drawStartScreen[1]);
//      const [wx,wy] = toWorld(sx,sy);
//
//      pushHistory();
//      if(movedPx < CLICK_THRESHOLD_PX){
//        // plain click -> MOVE
//        commands.push({t:'MOVE', x: drawStartWorld[0], y: drawStartWorld[1]});
//      } else {
//        // drag -> LINE (auto-insert a MOVE first, unless continuing from the last point)
//        const last = commands.length ? commands[commands.length-1] : null;
//        const continuesPath = last && last.x === drawStartWorld[0] && last.y === drawStartWorld[1];
//        if(!continuesPath) commands.push({t:'MOVE', x: drawStartWorld[0], y: drawStartWorld[1]});
//        commands.push({t:'LINE', x: wx, y: wy});
//      }
//      drawing = false; drawStartWorld = null; previewEnd = null;
//      renderAll();
//    }
//  });
//  canvas.addEventListener('mouseleave', ()=>{
//    panning = false; dragIndex = -1; drawing = false; previewEnd = null;
//    canvas.style.cursor = 'crosshair';
//  });
//
//  canvas.addEventListener('wheel', e=>{
//    e.preventDefault();
//    const [sx,sy] = getMousePos(e);
//    const [wx,wy] = toWorld(sx, sy, false); // world point under cursor, unsnapped
//
//    const factor = Math.pow(1.0015, -e.deltaY); // smooth, ~infinite range
//    const newPx = Math.min(MAX_PX, Math.max(MIN_PX, px * factor));
//
//    // keep the point under the cursor fixed on screen while zooming
//    originX = sx - wx * newPx;
//    originY = sy - wy * newPx;
//    px = newPx;
//
//    updateZoomReadout();
//    draw();
//  }, { passive:false });
//
//  document.getElementById('resetViewBtn').addEventListener('click', ()=>{
//    px = 16; originX = 40; originY = 40;
//    updateZoomReadout();
//    draw();
//  });
//
//  document.getElementById('snapGrid').addEventListener('change', e=> snap = e.target.checked);
//  document.getElementById('showGrid').addEventListener('change', draw);
//  document.getElementById('undoBtn').addEventListener('click', undo);
//  document.getElementById('clearBtn').addEventListener('click', ()=>{
//    if(commands.length && !confirm('Clear all commands?')) return;
//    pushHistory(); commands = []; renderAll();
//  });
//
//  // --- tabs ---
//  document.querySelectorAll('.tab-btn').forEach(btn=>{
//    btn.addEventListener('click', ()=>{
//      document.querySelectorAll('.tab-btn').forEach(b=>b.classList.remove('active'));
//      document.querySelectorAll('.tabpane').forEach(p=>p.classList.remove('active'));
//      btn.classList.add('active');
//      document.getElementById('tab-'+btn.dataset.tab).classList.add('active');
//    });
//  });
//
//  // --- style panel ---
//  ['fillEnabled','fillColor','fillAlpha','strokeEnabled','strokeColor','strokeAlpha','strokeThickness','iconName'].forEach(id=>{
//    document.getElementById(id).addEventListener('input', ()=>{
//      document.getElementById('fillAlphaVal').textContent = parseFloat(document.getElementById('fillAlpha').value).toFixed(2);
//      document.getElementById('strokeAlphaVal').textContent = parseFloat(document.getElementById('strokeAlpha').value).toFixed(2);
//      syncHexFields();
//      renderAll();
//    });
//  });
//  function syncHexFields(){
//    document.getElementById('fillColorHex').value = colorInputToHaxeHex(document.getElementById('fillColor'));
//    document.getElementById('strokeColorHex').value = colorInputToHaxeHex(document.getElementById('strokeColor'));
//  }
//  document.getElementById('fillColorHex').addEventListener('change', e=>{
//    try{ document.getElementById('fillColor').value = '#' + e.target.value.replace('0x','').replace('0X','').padStart(6,'0'); renderAll(); }catch(err){}
//  });
//  document.getElementById('strokeColorHex').addEventListener('change', e=>{
//    try{ document.getElementById('strokeColor').value = '#' + e.target.value.replace('0x','').replace('0X','').padStart(6,'0'); renderAll(); }catch(err){}
//  });
//  syncHexFields();
//
//  // --- copy ---
//  document.getElementById('copyBtn').addEventListener('click', ()=>{
//    const ta = document.getElementById('exportCode');
//    ta.select();
//    try{ document.execCommand('copy'); }catch(e){}
//    if(navigator.clipboard) navigator.clipboard.writeText(ta.value).catch(()=>{});
//    const btn = document.getElementById('copyBtn');
//    const old = btn.textContent; btn.textContent = 'Copied!';
//    setTimeout(()=> btn.textContent = old, 1200);
//  });
//
//  // --- import parser ---
//  document.getElementById('importBtn').addEventListener('click', ()=>{
//    const raw = document.getElementById('importCode').value;
//    const msg = document.getElementById('importMsg');
//    try{
//      const re = /\{\s*t\s*:\s*(MOVE|LINE)\s*,\s*a\s*:\s*\{\s*x\s*:\s*(-?[\d.]+)\s*,\s*y\s*:\s*(-?[\d.]+)\s*\}\s*\}/g;
//      let m, parsed = [];
//      while((m = re.exec(raw)) !== null){
//        parsed.push({t:m[1], x:parseFloat(m[2]), y:parseFloat(m[3])});
//      }
//      if(!parsed.length){ msg.textContent = 'No commands found — check the format matches {t:MOVE, a:{x:.., y:..}}.'; msg.style.color = 'var(--danger)'; return; }
//      pushHistory();
//      commands = parsed;
//      renderAll();
//      msg.textContent = `Loaded ${parsed.length} command(s).`;
//      msg.style.color = 'var(--accent)';
//    }catch(err){
//      msg.textContent = 'Parse error: ' + err.message;
//      msg.style.color = 'var(--danger)';
//    }
//  });
//
//  // resize canvas to holder
//  function fitCanvas(){
//    const r = holder.getBoundingClientRect();
//    canvas.width = Math.max(600, r.width);
//    canvas.height = Math.max(500, r.height);
//    draw();
//  }
//  window.addEventListener('resize', fitCanvas);
//  setTimeout(fitCanvas, 50);
//
//  updateZoomReadout();
//  renderAll();
//})();
//</script>
//</body>
//</html>
//