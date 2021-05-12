local JSON = require('lib/JSON');

local Clears = require('constants/Clears');
local Grades = require('constants/grades');

local ScoreNumber = require('components/common/scorenumber');

local getGrade = function(score)
  for _, curr in pairs(Grades) do
    if (score >= curr.min) then return curr.grade; end
  end
end

local kickUser = function(id)
  Tcp.SendLine(JSON.encode({ topic = 'room.kick', id = id }));
end

local makeHost = function(id)
  Tcp.SendLine(JSON.encode({ topic = 'room.host.set', host = id }));
end

---@class UsersClass
local Users = {
  -- Users constructor
  ---@param this UsersClass
  ---@param window Window
  ---@param mouse Mouse
  ---@param state Multiplayer
  ---@param constants table
  ---@return Users
  new = function(this, window, mouse, state, constants)
    ---@class Users : UsersClass
    local t = {
      cache = { w = 0, h = 0 },
      images = {
        btn = Image:new('buttons/short.png'),
        btnH = Image:new('buttons/short_hover.png'),
      },
      labels = {},
      margin = 0,
      mouse = mouse,
      state = state,
      userCount = 0,
      users = {},
      window = window,
      x = {
        btn = {},
        list = 0,
        text = {},
      },
      y = 0,
      w = 0,
      h = 0,
    };

    for name, str in pairs(constants) do
      t.labels[name] = makeLabel('med', str);
    end

    setmetatable(t, this);
    this.__index = this;

    return t;
  end,

  -- Sets the sizes for the current component
  ---@param this Users
  ---@param w number
  setSizes = function(this, w)
    if ((this.cache.w ~= this.window.w) or (this.cache.h ~= this.window.h)) then
      this.x.list = (this.window.w / 10) + w;
      this.y = this.window.h / 20;

      local wMax = this.window.w - ((this.window.w / 20) * 3) - w;
      local hMax = this.window.h - (this.window.h / 10);
      local spacing = wMax / 10;

      this.w = wMax;
      this.h = this.window.h / 11;

      this.margin = (hMax - (this.h * 8)) / 7;

      this.x.btn[1] = this.x.list + (this.w / 2) - (this.images.btn.w) - 64;
      this.x.btn[2] = this.x.list + (this.w / 2) + 64;

      this.x.text[1] = this.x.list + 24;
      this.x.text[2] = this.x.list + (spacing * 3.5);
      this.x.text[3] = this.x.list + (spacing * 4.75);
      this.x.text[4] = this.x.list + (spacing * 6.75);
      this.x.text[5] = this.x.list + (spacing * 8.25);

      this.cache.w = this.window.w;
      this.cache.h = this.window.h;
    end
  end,

  -- Parse and format user data
  ---@param this Users
  makeUsers = function(this)
    if (this.userCount ~= this.state.lobby.userCount) then
      this.users = {};

      for i = 1, this.state.lobby.userCount do
        this.users[i] = {
          clear = makeLabel('norm', '', 26),
          grade = makeLabel('norm', '', 26),
          level = makeLabel('num', '00', 26),
          player = makeLabel('norm', '', 26),
          score = ScoreNumber:new({ size = 26 }),
        };
      end
      
      this.userCount = this.state.lobby.userCount;
    end    
  end,

  -- Draw the list of users
  ---@param this Users
  drawUsers = function(this)
    local y = this.y;

    for i, user in ipairs(this.state.lobby.users) do
      y = y + this:drawUser(y, user, this.users[i]);
    end
  end,

  -- Draw a single user
  ---@param this Users
  ---@param y number
  ---@param user table
  ---@param text table
  drawUser = function(this, y, user, text)
    local lobby = this.state.lobby;
    local isHost = (lobby.host == this.state.user.id)
      and (user.id ~= this.state.user.id);
    local hovering = this.mouse:clipped(this.x.list, y, this.w, this.h);
    local status = 'notReady';

    if (lobby.host == user.id) then
      status = 'host';
    elseif (user.missing_map) then
      status = 'missing';
    elseif (user.ready) then
      status = 'ready';
    end

    drawRect({
      x = this.x.list,
      y = y,
      w = this.w,
      h = this.h,
      alpha = 120,
      color = 'dark',
    });

    if (isHost and hovering) then
      y = y + (this.h / 2) - (this.images.btn.h / 2);

      this:drawControls(y, user);
    else  
      y = y + (this.h / 5) + 2;

      local yText = y + (this.labels.clear.h * 1.35);

      this.labels[status]:draw({
        x = this.x.text[1],
        y = y,
        color = (user.missing_map and 'red')
          or (user.ready and { 48, 120, 48 })
          or 'norm',
      });

      text.player:draw({
        x = this.x.text[1],
        y = yText,
        color = 'white',
        text = user.name:upper(),
        update = true,
      });

      if (user.level and (user.level ~= 0)) then
        this.labels.level:draw({ x = this.x.text[2], y = y });

        text.level:draw({
          x = this.x.text[2],
          y = yText,
          color = 'white',
          text = ('%02d'):format(user.level),
          update = true,
        });
      end

      if (user.score) then
        this.labels.score:draw({ x = this.x.text[3], y = y });

        text.score:draw({
          x = this.x.text[3],
          y = yText,
          val = user.score,
        });

        this.labels.grade:draw({ x = this.x.text[4], y = y });

        text.grade:draw({
          x = this.x.text[4],
          y = yText,
          color = 'white',
          text = getGrade(user.score),
          update = true,
        });

        this.labels.clear:draw({ x = this.x.text[5], y = y });

        text.clear:draw({
          x = this.x.text[5],
          y = yText,
          color = 'white',
          text = (Clears[user.clear] and Clears[user.clear].clear) or 'EXIT',
          update = true,
        });
      end
    end

    return this.h + this.margin;
  end,

  ---@param this Users
  ---@param y number
  ---@param user table
  drawControls = function(this, y, user)
    local x1 = this.x.btn[1];
    local x2 = this.x.btn[2];
    local w = this.images.btn.w;
    local h = this.images.btn.h;
    local hostHover = this.mouse:clipped(x1, y, w, h);
    local kickHover = this.mouse:clipped(x2, y, w, h);

    if (hostHover) then
      this.state.btnEvent = function() makeHost(user.id) end;

      this.images.btnH:draw({ x = x1, y = y });
    else
      this.images.btn:draw({
        x = x1,
        y = y,
        alpha = 0.75,
      });
    end

    this.labels.makeHost:draw({
      x = x1 + 32,
      y = y + 19,
      alpha = (hostHover and 255) or 150,
      color = 'white',
    });

    if (kickHover) then
      this.state.btnEvent = function() kickUser(user.id) end;

      this.images.btnH:draw({ x = x2, y = y });
    else
      this.images.btn:draw({
        x = x2,
        y = y,
        alpha = 0.75,
      });
    end

    this.labels.kick:draw({
      x = x2 + 32,
      y = y + 19,
      alpha = (kickHover and 255) or 150,
      color = 'white',
    });
  end,

  -- Renders the current component
  ---@param this Users
  ---@param w number
  render = function(this, w)
    this:setSizes(w);

    this:makeUsers();

    gfx.Save();

    if (this.userCount > 0) then this:drawUsers(); end

    gfx.Restore();
  end,
};

return Users;