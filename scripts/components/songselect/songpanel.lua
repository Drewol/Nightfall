local Difficulties = require('constants/difficulties');
local Labels = require('constants/songwheel');

local Cursor = require('components/common/cursor');
local ScoreNumber = require('components/common/scorenumber');
local SearchBar = require('components/common/searchbar');

-- Drawing order
local Order = {
  'title',
  'artist',
  'effector',
  'bpm',
};

local floor = math.floor;

-- Gets the difficulty within range 1-4
---@param diffs CachedDiff[]
---@param i integer
---@return CachedDiff
local getDiff = function(diffs, i)
  local index = nil;

  for j, diff in ipairs(diffs) do
    if ((diff.diff + 1) == i) then index = j; end
  end

  return diffs[index];
end

---@class SongPanelClass
local SongPanel = {
  -- SongPanel constructor
  ---@param this SongPanelClass
  ---@param window Window
  ---@param state SongWheel
  ---@param songs SongCache
  ---@return SongPanel
  new = function(this, window, state, songs)
    ---@class SongPanel : SongPanelClass
    ---@field labels table<string, Label>
    ---@field songs SongCache
    ---@field state SongWheel
    ---@field window Window
    local t = {
      cache = { w = 0, h = 0 },
      currDiff = 0,
      currSong = 0,
      cursor = Cursor:new({
        size = 12,
        stroke = 1.5,
        type = 'vertical',
      }),
      cursorIdx = 0,
      diffs = {},
      highScore = ScoreNumber:new({ size = 100 }),
      images = {
        btn = Image:new('buttons/short.png'),
        btnH = Image:new('buttons/short_hover.png'),
        panel = Image:new('common/panel.png'),
        panelPortrait = Image:new('common/panel_wide.png'),
      },
      innerWidth = 0,
      jacketSize = 0,
      labels = {
        peak = makeLabel('med', 'PEAK', 18),
        peakVal = makeLabel('num', '0', 18)
      },
      padding = {
        x = { double = 0, full = 0 },
        y = { double = 0, full = 0 },
      },
      searchBar = SearchBar:new();
      songs = songs,
      state = state,
      timers = {
        artist = 0,
        effector = 0,
        title = 0,
      },
      window = window,
      x = 0,
      y = 0,
      w = 0,
      h = 0,
      count = 0,
    };

    for i, diff in ipairs(Difficulties) do
      t.diffs[i] = makeLabel('med', diff);
    end

    ---@param name string
    ---@param str string
    for name, str in pairs(Labels) do
      t.labels[name] = makeLabel('med', str);
    end

    setmetatable(t, this);
    this.__index = this;

    return t;
  end,

  -- Sets the sizes for the current component
  ---@param this SongPanel
  setSizes = function(this)
    if ((this.cache.w ~= this.window.w) or (this.cache.h ~= this.window.h)) then
      if (this.window.isPortrait) then
        this.jacketSize = this.window.w // 4.75;

        this.w = this.window.w - (this.window.padding.x * 2);
        this.h = this.window.h // 2.9;

        this.padding.x.full = this.w / 36;
        this.padding.y.full = this.h / 18;

        this.highScore = ScoreNumber:new({ size = 120 });
      else
        this.jacketSize = this.window.w // 5;

        this.w = this.window.w / (1920 / this.images.panel.w);
        this.h = this.window.h - (this.window.padding.y * 2);

        this.padding.x.full = this.w / 24;
        this.padding.y.full = this.h / 20;

        this.highScore = ScoreNumber:new({ size = 100 });
      end

      this.x = this.window.padding.x;
      this.y = this.window.padding.y;
      this.middle = this.w / 2;

      this.padding.x.double = this.padding.x.full * 2;
      this.padding.y.double = this.padding.y.full * 2;

      if (this.window.isPortrait) then
        this.innerWidth = this.w
          - this.jacketSize
          - this.padding.x.double
          - (this.padding.x.double * 2);
      else
        this.innerWidth = this.w - (this.padding.x.double * 2);
      end

      if (this.window.isPortrait) then
        this.cursor:setSizes({
          x = this.x + this.padding.x.full + 23,
          y = this.y
            + this.jacketSize
            + this.padding.y.double
            + this.labels.difficulty.h
            - 6,
          w = this.jacketSize + 5,
          h = this.images.btn.h - 8,
          margin = (this.images.btn.h / 2.5) + 8,
        });

        this.searchBar:setSizes({
          x = this.x - 8,
          y = this.y + this.h + (this.window.padding.y / 3) + 2,
          w = this.w + 8,
          h = this.window.padding.y * 0.8,
        });
      else
        this.cursor:setSizes({
          x = this.x
            + this.padding.x.double
            + this.jacketSize
            + this.padding.x.full
            + 16,
          y = this.y
            + this.padding.y.double
            + this.labels.difficulty.h
            - 20,
          w = this.images.btn.w - 8,
          h = this.images.btn.h - 8,
          margin = (this.images.btn.h / 2.5) + 8,
        });

        this.searchBar:setSizes({
          x = this.x - 2,
          y = this.y / 2,
          w = this.w + 3,
          h = this.window.h / 22,
        });
      end

      this.cache.w = this.window.w;
      this.cache.h = this.window.h;
    end
  end,

  -- Draw the chart jacket
  ---@param this SongPanel
  ---@param diff CachedDiff
  drawJacket = function(this, diff)
    local size = this.jacketSize;
    local x = this.padding.x.double;
    local y = this.padding.y.full;

    drawRect({
      x = x,
      y = y,
      w = size,
      h = size,
      image = diff.jacket,
      stroke = { color = 'norm', size = 2 },
    });

    if (diff.best) then
      local labels = diff.best.labels.large;

      if (this.window.isPortrait) then
        labels = diff.best.labels.small;

        drawRect({
          x = x + 8,
          y = y + 8,
          w = 98,
          h = 32,
          color = 'dark',
        });

        labels.best:draw({
          x = x + 16,
          y = y + 12,
          color = 'white',
        });
  
        labels[diff.best.place]:draw({
          x = x + 16 + labels.best.w + 8,
          y = y + 12,
        });
      else
        drawRect({
          x = x + 12,
          y = y + 12,
          w = 141,
          h = 42,
          color = 'dark',
        });

        labels.best:draw({
          x = x + 20,
          y = y + 15,
          color = 'white',
        });
  
        labels[diff.best.place]:draw({
          x = x + 20 + labels.best.w + 12,
          y = y + 15,
        });
      end
    end

    if (getSetting('showDensity', true) and diff.densityData) then
      this:normalizeDensity(diff);

      local scale = (size - 4) / #diff.densityData;

      drawRect({
        x = x + 1,
        y = y + (size * 0.75) - 7,
        w = size - 2,
        h = (size / 4) + 6,
        alpha = 200,
        color = 'black',
      });

      this.labels.peak:draw({
        x = x + 5,
        y = y + (size * 0.75) - 5,
        color = 'red',
      });

      this.labels.peakVal:draw({
        x = x + 5 + this.labels.peak.w + 8,
        y = y + (size * 0.75) - 5,
        color = 'white',
        text = diff.densityPeak,
        update = true,
      });

      setFill('norm');
      gfx.BeginPath();
      gfx.MoveTo(x + 2, y + size - 1);

      for i, v in ipairs(diff.densityData) do
        gfx.LineTo((x + 3) + (i * scale), (y + size - 1) - v);
      end

      gfx.LineTo(x + size, y + size);
      gfx.LineTo(x, y + size);
      gfx.ClosePath();
      gfx.Fill();
    end
  end,

  -- Draw the song info
  ---@param this SongPanel
  ---@param dt deltaTime
  ---@param cached CachedSong
  ---@param diff CachedDiff
  drawInfo = function(this, dt, cached, diff)
    local multi = (this.window.isPortrait and 1.9) or 1;
    local x = this.padding.x.double;
    local xGrade = x + (this.padding.x.full * 4.5);
    local y = (this.padding.y.double * 0.75) + this.jacketSize;

    if (this.window.isPortrait) then
      x = (this.padding.x.double * 2) + this.jacketSize;
      xGrade = x + (this.padding.x.full * 7);
      y = this.padding.y.full - 5;
    end

    ---@param name string
    for _, name in ipairs(Order) do
      local label = cached[name] or diff[name];

      this.labels[name]:draw({ x = x, y = y });

      if ((label.w > this.innerWidth) and this.timers[name]) then
        this.timers[name] = this.timers[name] + dt;

        label:drawScrolling({
          x = x,
          y = y + (this.labels[name].h * 1.35),
          color = 'white',
          scale = this.window:getScale(),
          timer = this.timers[name],
          width = this.innerWidth,
        });
      else
        label:draw({
          x = x,
          y = y + (this.labels[name].h * 1.35),
          color = 'white',
        });
      end

      y = y
        + (this.labels[name].h * 1.35)
        + (label.h * multi)
        + ((this.padding.y.full / 4) * 1.35);
    end

    if (diff.clear and diff.grade) then
      this.labels.grade:draw({ x = x, y = y });

      diff.grade:draw({
        x = x,
        y = y + (this.labels.grade.h * 1.25),
        color = 'white',
      });

      this.labels.clear:draw({ x = xGrade, y = y });

      diff.clear:draw({
        x = xGrade,
        y = y + (this.labels.clear.h * 1.25);
        color = 'white',
      });

      y = y
        + (this.labels.clear.h * 1.35)
        + (diff.clear.h * multi)
        + ((this.padding.y.full / 4) * 1.35);

      this.labels.highScore:draw({ x = x, y = y });

      this.highScore:draw({
        x = x - ((this.window.isPortrait and 7) or 4),
        y = y + (this.labels.highScore.h * 0.5),
        val = diff.highScore,
      });
    end
  end,

  -- Draw a single diff
  ---@param this SongPanel
  ---@param y number
  ---@param diff CachedDiff
  ---@param isCurr boolean
  ---@return number
  drawDiff = function(this, y, diff, isCurr)
    local x = this.padding.x.double + this.jacketSize + this.padding.x.full + 12;
    local w = this.images.btn.w;

    if (this.window.isPortrait) then
      x = this.padding.x.double - 8;
      w = this.jacketSize + 14;
    end

    if (isCurr) then
      this.images.btnH:draw({
        x = x,
        y = y,
        w = w,
      });
    else
      this.images.btn:draw({
        x = x,
        y = y,
        w = w,
        alpha = 0.6,
      });
    end

    if (diff) then
      local i = getDiffIndex(diff.jacketPath, diff.diff);

      this.diffs[i]:draw({
        x = x + (w / 7),
        y = y + (this.images.btn.h / 2) - 12,
        alpha = 255 * ((isCurr and 1) or 0.35),
        color = 'white',
      });

      diff.level:draw({
        x = x + w - (w / 7),
        y = y + (this.images.btn.h / 2) - 12,
        align = 'right',
        alpha = 255 * ((isCurr and 1) or 0.35),
        color = 'white',
      });
    end

    return this.images.btn.h + (this.images.btn.h / 2.5);
  end,

  -- Draw the song panel
  ---@param this SongPanel
  ---@param dt deltaTime
  drawPanel = function(this, dt)
    local song = songwheel.songs[this.state.currSong];
    local x = this.padding.x.double + this.jacketSize + this.padding.x.full + 15;
    local y = this.padding.y.double + this.labels.difficulty.h - 24;
    local yLabel = this.padding.y.full - 5;
    local cached, diff;

    if (this.window.isPortrait) then
      x = this.padding.x.double - 3;
      y = (this.padding.y.full * 2)
        + this.jacketSize
        + this.labels.difficulty.h
        - 10;
      yLabel = (this.padding.y.full * 2) + this.jacketSize - 24;

      this.images.panelPortrait:draw({
        x = this.x,
        y = this.y,
        w = this.w,
        h = this.h,
        alpha = 0.75,
      });
    else
      this.images.panel:draw({
        x = this.x,
        y = this.y,
        w = this.w,
        h = this.h,
        alpha = 0.75,
      });  
    end

    cached = this.songs:get(song);

    if (not cached) then return; end

    diff = cached.diffs[this.state.currDiff] or cached.diffs[1];

    gfx.Save();

    gfx.Translate(this.x, this.y);

    this:drawJacket(diff);

    this:drawInfo(dt, cached, diff);

    this.labels.difficulty:draw({ x = x, y = yLabel });

    for i = 1, 4 do
      local currDiff = getDiff(cached.diffs, i);
      local isCurr = diff.diff == (i - 1);

      if (isCurr) then this.cursorIdx = i; end

      y = y + this:drawDiff(y, currDiff, isCurr);
    end

    gfx.Restore();
  end,

  -- Normalize density graph to a portion of jacket size
  ---@param this SongPanel
  ---@param diff CachedDiff
  normalizeDensity = function(this, diff)
    if (diff.densityNormalized) then return; end

    -- Backwards compatibility
    local normalized = false;

    for _, v in ipairs(diff.densityData) do
      if (v == 96) then normalized = true; break; end
    end

    if (normalized) then
      diff.densityPeak = diff.densityData[#diff.densityData];

      if (this.window.isPortrait) then  
        local scale = (this.jacketSize / 4) / 96;

        for i, v in ipairs(diff.densityData) do
          diff.densityData[i] = floor(v * scale);
        end
      end

      diff.densityNormalized = true;
      diff.densityData[#diff.densityData] = nil;
      
      return;
    end

    local setMax = false;
    local max = -1;
    local scale = 1;

    for _, v in ipairs(diff.densityData) do if (v > max) then max = v; end end

    setMax = max == -1;

    if (max == 0) then max = 1; end

    scale = (this.jacketSize / 4) / max;

    for i, v in ipairs(diff.densityData) do
      diff.densityData[i] = floor(v * scale);
    end

    diff.densityNormalized = true;
    diff.densityPeak = (setMax and 0) or max;
  end,

  -- Resets the timers when the song is changed
  ---@param this SongPanel
  resetTimers = function(this)
    this.timers.artist = 0;
    this.timers.effector = 0;
    this.timers.title = 0;
  end,

  -- Handles song and difficulty changes
  ---@param this SongPanel
  handleChange = function(this)
    if (this.currDiff ~= this.state.currDiff) then
      this:resetTimers();

      this.currDiff = this.state.currDiff;
    end

    if (this.currSong ~= this.state.currSong) then
      this:resetTimers();

      this.currSong = this.state.currSong;
    end
  end,

  -- Renders the current component
  ---@param this SongPanel
  ---@param dt deltaTime
  ---@return number
  render = function(this, dt)
    this:setSizes();

    this:handleChange();

    gfx.Save();

    this:drawPanel(dt);

    if (songwheel.songs[this.state.currSong]) then
      this.cursor:render(dt, { curr = this.cursorIdx, total = 4 });
    end

    this.searchBar:render(dt, {
      input = songwheel.searchText,
      isActive = songwheel.searchInputActive,
    });

    gfx.Restore();

    return this.w, this.h;
  end,
};

return SongPanel;