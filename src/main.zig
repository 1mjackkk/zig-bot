const std = @import("std");
const time = std.time;
const heap = std.heap;
const Thread = std.Thread;
const Atomic = std.atomic.Atomic;

pub const OWNER_ID: i64 = 8817232625;
pub const SUDO_FILE = "sudo.json";
pub const CMD_PREFIX: u8 = '.';

pub const INITIAL_BOT_TOKENS = [_][]const u8{
    "8743415286:AAFEUhvxJCa8WhlvYzXAIZQ7g3pi8OrH6ik",
};

pub const UNAUTHORIZED_MSG = "𝘊𝘏𝘓 𝘙𝘕𝘋𝘠𝘒𝘌 𝘝𝘐𝘚𝘏𝘜 𝘎𝘌𝘕𝘖𝘚 𝘒𝘈 𝘓𝘕𝘋 𝘊𝘏𝘜𝘚 𝘗𝘏𝘓𝘌💥";

// ── Emoji & Word Arrays ──
pub const GENOSNC_EMOJIS = [_][]const u8{ "🎀", "🌸", "💮", "🪷", "🏵️", "🌹", "🥀", "🌺", "🌻", "🌼", "🌷", "🪻", "⚜️", "🍀", "☘️", "🌿", "🍃", "🍂", "🍁", "🌱", "🌾", "✨", "💫", "⭐", "🌟", "🌙", "🧿", "🔮", "🦋", "🕊️", "🎧", "🎭", "🕯️", "🫧", "🪶", "💖", "💗", "💓" };
pub const TIME_EMOJIS = [_][]const u8{ "⏱️", "⏰", "⌛", "⏳", "🕐", "🕒", "🕔", "🕖", "🕘", "🕚", "⚡", "✨", "💫" };
pub const VISHU_EMOJIS = [_][]const u8{ "🍡", "㊗️", "🕷️", "🚗", "🩸", "🦠", "💐", "🌇", "🔥", "⚡", "💥", "☠️", "💀", "🖤", "🌑", "🔱", "⚔️", "🌀", "🌩️", "✨", "💫", "🌙", "⭐", "🦋", "🫧", "🌸", "🕊️", "🔮", "🧿", "🪶" };
pub const VISHUNC_WORD = [_][]const u8{ "2-3 ⱮƛӇƖƝЄ ӇƲЄ ƝƛӇƖ ӇƛƓƝЄ ԼƓЄ ???? 🤣", "ⱦєяє ɠɦαя кι αυятση кι вяα ƒαα∂ к αρηα кυятα ѕιℓωαυ яη∂ук ???? 🤣", "ƓƦƖƁ Ɱƛ Ƙ ƁƛƇӇƳ ƓӇƛƦ ⱮЄ ƛƬƬƛ ԼЄ ƛƛ ???? 🤣", "ƬЄƦƖ Ɱƛƛ Ƙƛ ƁӇƧƊƛ ???? 🤣", "ƬЄƦƖ Ɱƛ ƇӇƠƊƲƝ ???? 🤣", "ⱮƛƇƇӇƛƦ ƬⱮƘƇ ???? 🤣", "ƁƖӇƛƦƖ ƓƛƝƓ ƬЄƦƖ Ɱƛ ƇӇƠƊƲƝ ???? 🤣", "ƬⱮƘƇ ???? 🤣", "ƬⱮƘƁ ???? 🤣", "ƦƝƊƘ ƁƛƇӇƳ ???? 🤣" };
pub const FLAG_EMOJIS = [_][]const u8{ "🏁", "🚩", "🎌", "🏴", "🇦🇫", "🇦🇱", "🇩🇿", "🇦🇷", "🇦🇺", "🇧🇩", "🇧🇪", "🇧🇷", "🇨🇦", "🇨🇳", "🇩🇰", "🇪🇬", "🇫🇷", "🇩🇪", "🇮🇳", "🇮🇩", "🇮🇹", "🇯🇵", "🇰🇷", "🇲🇾", "🇲🇽", "🇳🇵", "🇳🇱", "🇵🇰", "🇵🇭", "🇵🇱", "🇷🇺", "🇸🇦", "🇸🇬", "🇿🇦", "🇪🇸", "🇹🇷", "🇦🇪", "🇬🇧", "🇺🇸" };
pub const NCEMO_EMOJIS = [_][]const u8{ "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "🥲", "🥹", "☺️", "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🤩", "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "🥺", "😢", "😭", "😮‍💨", "😤", "😠", "😡", "🤬", "🤯", "😳", "🥵", "🥶", "😱" };
pub const HEART_EMOJIS = [_][]const u8{ "💖", "💗", "💓", "💞", "💕", "❤️", "🖤", "🩵", "💜", "💙", "💚", "💛", "🧡", "🤍", "🪶", "❣️" };
pub const VILLAIN_EMOJIS = [_][]const u8{ "🏴‍☠️", "☠️", "💀", "👿", "👺", "🩸", "🔪", "⚔️", "👑", "🇦🇨", "⚡", "🔥", "💥", "🔱", "⛓️", "🖤" };
pub const CRY_EMOJIS = [_][]const u8{ "😭", "💔", "🥺", "🥹", "😢", "😞", "😔", "😿", "🫂", "🤍", "🌧️", "❄️", "🌊", "💧", "🫧", "☁️", "🕊️", "🪽", "🌺", "🌸" };
pub const NC5_EMOJIS = [_][]const u8{ " 🅱🅻🅾🅾🅳🆈 🅷🅴🅻🅻.𖥔 ݁ ˖ִ🛸༄˖°.", " 🅼🅾🆃🅷🅴🆁🅵🆄🅲🅺🅴🆁🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧", " 🅱🅸🆃🅲🅷 🆂🅾🅽.𖥔 ݁ ˖ִ🛸༄˖°.", "🆂🅻🅰🆅🅴🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧", " 🆂🅾🅽 🅾🅵 🅼🅸🅰 🅺🅷🅰🅻🅸🅵🅰 .𖥔 ݁ ˖ִ🛸༄˖°.", "🆂🅰🆈 🅶🅴🅽🅾🆂 🅳🅰🅳🅳🆈🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧", "🅵🆄🅲🅺🅽🄶 🅲🅴🅽🆃🆁🅴.𖥔 ݁ ˖ִ🛸༄˖°.", " 🆂🅾🅽 🅵🆄🅲🅺🅴🅳 🅼🅾🅼🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧" };
pub const ALL_EMOJIS = [_][]const u8{ "💯", "💢", "💥", "💫", "💦", "💨", "🕳️", "💣", "💬", "👋", "👌", "✌️", "🤞", "🤟", "🤘", "👍", "👎", "✊", "👊", "👏", "🙌", "🫶", "💪", "🧠", "👀", "👁️", "🐶", "🐱", "🐭", "🦁", "🐵", "🦅", "🦉", "🦇", "🐺", "🦄", "🐝", "🦋", "🕷️", "🐍", "🐙", "🐬", "🦈", "🐅", "🌸", "🌹", "🔥", "⚡️", "🌈", "👑", "🎲", "🎯", "🚗", "🚀", "🛸", "⛵️", "🛑", "🔔", "📢", "♠️", "♥️", "♦️", "♣️" };
pub const CHUD_WORD = [_][]const u8{ "कमजोर रण्डी 🩶᭪", "कमजोर रण्डी 🩵᭪", "TERI बहन KI BRA 👙", "TERI माँ KI BRA 👙", "𝘛𝘈𝘛𝘛𝘌💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "𝘙𝘕𝘋 💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "𝘛𝘔𝘒𝘉💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "𝘓𝘈𝘕𝘋 𝘓𝘌💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "चुद पुत्र ִֶ 𓂃🏴‍☠️⊹", "तू लंड पे(🍂)ᝰ.ᐟ", "रण्डी(🍂)ᝰ.ᐟ", "चक्का(🍂)ᝰ.ᐟ" };
pub const SPAM_DEFAULT_MSGS = [_][]const u8{ " ོ༘₊⁺🇮🇳 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐈ɴᴅɪᴀ 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇮🇳 ₊⁺⋆.˚", " ོ༘₊⁺🇯🇵 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐉ᴀᴘᴀɴ 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇯🇵 ₊⁺⋆. ", " ₊⁺🇺🇸 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐔𝐒𝐀 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇺🇸 ₊⁺⋆.˚", " ོ༘₊⁺🇬🇧 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐔𝐊 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇬🇧 ₊⁺⋆.˚" };
pub const SWIPE_MSGS = [_][]const u8{ "𝐊ʏᴀ 𝐑ᴇ 𝐑ᴀɴᴅɪᴋᴇ 𝐂ᴏᴏʟ 𝐁ᴀɴᴇɢᴀ 𝐓ᴜ 𝐂ʜᴀʟ 𝐀ʙ 𝐂ʜᴜᴅ 𝐀ᴘɴᴇ 𝐁ᴀᴀᴘ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐒ᴇ - 🦢💘", "𝐊ɪ 𝐌ᴀᴀ 𝐌ᴀʀʀ 𝐆ᴀʏɪ 𝐘ᴀᴀʀ - 𝐉ᴀɪ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs ! 🌙", "acha beta 😂🔥👊🏻 ? coi na me toh HATER codunga 😹💔🔥😆👊🏻💥", "chudke bhaga kaise 😂💥🤣🤘🏻", "ne toh 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs ka lun muh me lelia 😂🙏🏻😂🙏🏻", "𝗧ᴍᴋ𝗕 pe 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs ka hamla 😂⚔🔥💥" };

// ── Hardware Metrics (/proc parser) ──
pub const SystemMetrics = struct { ram_mb: f64, cpu_percent: f64 };
var prev_cpu_time: u64 = 0;
var prev_sample_time: i64 = 0;

pub fn getSystemMetrics() SystemMetrics {
    var ram_mb: f64 = 0.0;
    var cpu_percent: f64 = 0.0;
    if (std.fs.cwd().openFile("/proc/self/statm", .{})) |file| {
        defer file.close();
        var buf: [128]u8 = undefined;
        if (file.readAll(&buf)) |bytes| {
            var it = std.mem.tokenizeScalar(u8, buf[0..bytes], ' ');
            _ = it.next();
            if (it.next()) |res_str| {
                if (std.fmt.parseInt(u64, res_str, 10)) |pages| {
                    ram_mb = (@as(f64, @floatFromInt(pages)) * 4096.0) / (1024.0 * 1024.0);
                } else |_| {}
            }
        } else |_| {}
    } else |_| {}

    if (std.fs.cwd().openFile("/proc/self/stat", .{})) |file| {
        defer file.close();
        var buf: [1024]u8 = undefined;
        if (file.readAll(&buf)) |bytes| {
            var it = std.mem.tokenizeScalar(u8, buf[0..bytes], ' ');
            var idx: usize = 0;
            var utime: u64 = 0;
            var stime: u64 = 0;
            while (it.next()) |tok| : (idx += 1) {
                if (idx == 13) utime = std.fmt.parseInt(u64, tok, 10) catch 0;
                if (idx == 14) {
                    stime = std.fmt.parseInt(u64, tok, 10) catch 0;
                    break;
                }
            }
            const total = utime + stime;
            const now = time.milliTimestamp();
            if (prev_sample_time > 0 and now > prev_sample_time) {
                const dt = @as(f64, @floatFromInt(now - prev_sample_time)) / 1000.0;
                const d_ticks = @as(f64, @floatFromInt(total -| prev_cpu_time));
                cpu_percent = std.math.clamp((d_ticks / 100.0) / dt * 100.0, 0.0, 100.0);
            }
            prev_cpu_time = total;
            prev_sample_time = now;
        } else |_| {}
    } else |_| {}
    return .{ .ram_mb = ram_mb, .cpu_percent = cpu_percent };
}

pub fn truncTitle(raw: []const u8) []const u8 {
    if (raw.len <= 255) return raw;
    var cut: usize = 255;
    while (cut > 0 and (raw[cut] & 0xC0) == 0x80) cut -= 1;
    return raw[0..cut];
}

pub fn doubleStruck(allocator: std.mem.Allocator, text: []const u8) ![]u8 {
    var out = std.ArrayList(u8).init(allocator);
    for (text) |c| {
        if (c >= 'A' and c <= 'Z') {
            var buf: [4]u8 = undefined;
            const len = try std.unicode.utf8Encode(@as(u21, 0x1D538 + (c - 'A')), &buf);
            try out.appendSlice(buf[0..len]);
        } else if (c >= 'a' and c <= 'z') {
            var buf: [4]u8 = undefined;
            const len = try std.unicode.utf8Encode(@as(u21, 0x1D552 + (c - 'a')), &buf);
            try out.appendSlice(buf[0..len]);
        } else if (c >= '0' and c <= '9') {
            var buf: [4]u8 = undefined;
            const len = try std.unicode.utf8Encode(@as(u21, 0x1D7D8 + (c - '0')), &buf);
            try out.appendSlice(buf[0..len]);
        } else {
            try out.append(c);
        }
    }
    return out.toOwnedSlice();
}

// ── Bot Client ──
pub const BotClient = struct {
    token: []const u8,
    id: i64,
    username: []const u8,
    is_leader: bool,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, token: []const u8, is_leader: bool) BotClient {
        return .{
            .token = allocator.dupe(u8, token) catch token,
            .id = 0,
            .username = "",
            .is_leader = is_leader,
            .allocator = allocator,
        };
    }

    pub fn makeApiCall(self: *BotClient, method: []const u8, json_payload: []const u8) ![]u8 {
        var client = std.http.Client{ .allocator = self.allocator };
        defer client.deinit();

        const url = try std.fmt.allocPrint(self.allocator, "https://api.telegram.org/bot{s}/{s}", .{ self.token, method });
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);
        var headers = std.http.Headers{ .allocator = self.allocator };
        defer headers.deinit();
        try headers.append("content-type", "application/json");

        var req = try client.request(.POST, uri, headers, .{});
        defer req.deinit();

        req.transfer_encoding = .{ .content_length = json_payload.len };
        try req.start();
        try req.writeAll(json_payload);
        try req.finish();
        try req.wait();

        return try req.reader().readAllAlloc(self.allocator, 1024 * 1024);
    }

    pub fn sendMessage(self: *BotClient, chat_id: i64, text: []const u8, reply_to: ?i64) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();
        if (reply_to) |rep| {
            try std.json.stringify(.{ .chat_id = chat_id, .text = text, .reply_to_message_id = rep }, .{}, json_buf.writer());
        } else {
            try std.json.stringify(.{ .chat_id = chat_id, .text = text }, .{}, json_buf.writer());
        }
        const res = try self.makeApiCall("sendMessage", json_buf.items);
        self.allocator.free(res);
    }

    pub fn setChatTitle(self: *BotClient, chat_id: i64, title: []const u8) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();
        try std.json.stringify(.{ .chat_id = chat_id, .title = title }, .{}, json_buf.writer());
        const res = try self.makeApiCall("setChatTitle", json_buf.items);
        self.allocator.free(res);
    }

    pub fn promoteAdmin(self: *BotClient, chat_id: i64, user_id: i64) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();
        try std.json.stringify(.{
            .chat_id = chat_id, .user_id = user_id, .can_change_info = true, .can_post_messages = true,
            .can_edit_messages = true, .can_delete_messages = true, .can_invite_users = true,
            .can_restrict_members = true, .can_pin_messages = true, .can_promote_members = true,
            .can_manage_chat = true, .can_manage_video_chats = true,
        }, .{}, json_buf.writer());
        const res = try self.makeApiCall("promoteChatMember", json_buf.items);
        self.allocator.free(res);
    }

    pub fn leaveChat(self: *BotClient, chat_id: i64) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();
        try std.json.stringify(.{ .chat_id = chat_id }, .{}, json_buf.writer());
        const res = try self.makeApiCall("leaveChat", json_buf.items);
        self.allocator.free(res);
    }

    pub fn fetchMe(self: *BotClient) !bool {
        const res = try self.makeApiCall("getMe", "{}");
        defer self.allocator.free(res);
        var parsed = try std.json.parseFromSlice(std.json.Value, self.allocator, res, .{});
        defer parsed.deinit();
        if (parsed.value.object.get("ok")) |ok| {
            if (ok.bool) {
                const res_obj = parsed.value.object.get("result").?.object;
                self.id = res_obj.get("id").?.integer;
                if (res_obj.get("username")) |un| self.username = try self.allocator.dupe(u8, un.string);
                return true;
            }
        }
        return false;
    }
};

// ── Global State ──
pub const GlobalState = struct {
    allocator: std.mem.Allocator,
    start_time: i64,
    nc_count: Atomic(u64),
    mutex: Thread.Mutex,
    sudo_set: std.AutoHashMap(i64, void),
    battalion: std.ArrayList(*BotClient),
    active_nc: std.AutoHashMap(i64, *Atomic(bool)),
    active_spam: std.AutoHashMap(i64, *Atomic(bool)),
    active_swipe: std.AutoHashMap(i64, *Atomic(bool)),

    pub fn init(allocator: std.mem.Allocator) GlobalState {
        return .{
            .allocator = allocator,
            .start_time = time.timestamp(),
            .nc_count = Atomic(u64).init(0),
            .mutex = .{},
            .sudo_set = std.AutoHashMap(i64, void).init(allocator),
            .battalion = std.ArrayList(*BotClient).init(allocator),
            .active_nc = std.AutoHashMap(i64, *Atomic(bool)).init(allocator),
            .active_spam = std.AutoHashMap(i64, *Atomic(bool)).init(allocator),
            .active_swipe = std.AutoHashMap(i64, *Atomic(bool)).init(allocator),
        };
    }

    pub fn isSudo(self: *GlobalState, uid: i64) bool {
        if (uid == OWNER_ID) return true;
        self.mutex.lock();
        defer self.mutex.unlock();
        return self.sudo_set.contains(uid);
    }

    pub fn stopNc(self: *GlobalState, chat_id: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if (self.active_nc.get(chat_id)) |flag| flag.store(false, .Monotonic);
    }
    pub fn stopSpam(self: *GlobalState, chat_id: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if (self.active_spam.get(chat_id)) |flag| flag.store(false, .Monotonic);
    }
    pub fn stopSwipe(self: *GlobalState, chat_id: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if (self.active_swipe.get(chat_id)) |flag| flag.store(false, .Monotonic);
    }
};

var global_state: GlobalState = undefined;

// ── NC Worker Runner ──
const NcWorkerContext = struct { bot: *BotClient, chat_id: i64, titles: [][]const u8, flag: *Atomic(bool) };
fn ncWorkerThread(ctx: NcWorkerContext) void {
    var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
    const random = prng.random();
    while (ctx.flag.load(.Monotonic)) {
        const title = ctx.titles[random.uintLessThan(usize, ctx.titles.len)];
        ctx.bot.setChatTitle(ctx.chat_id, title) catch {
            time.sleep(100 * time.ns_per_ms);
            continue;
        };
        _ = global_state.nc_count.fetchAdd(1, .Monotonic);
        time.sleep(50 * time.ns_per_ms);
    }
}

pub fn startNcRelay(chat_id: i64, titles: [][]const u8) !void {
    global_state.stopNc(chat_id);
    const flag = try global_state.allocator.create(Atomic(bool));
    flag.* = Atomic(bool).init(true);
    global_state.mutex.lock();
    try global_state.active_nc.put(chat_id, flag);
    const bots_copy = try global_state.battalion.clone();
    global_state.mutex.unlock();
    defer bots_copy.deinit();

    for (bots_copy.items) |bot| {
        const handle = try Thread.spawn(.{}, ncWorkerThread, .{NcWorkerContext{
            .bot = bot, .chat_id = chat_id, .titles = titles, .flag = flag,
        }});
        handle.detach();
    }
}

// ── Command Handler & Generator ──
pub fn handleCommand(bot: *BotClient, chat_id: i64, user_id: i64, text: []const u8, reply_user_id: ?i64) !void {
    if (text.len == 0 or text[0] != CMD_PREFIX) return;
    var it = std.mem.tokenizeScalar(u8, text[1..], ' ');
    const cmd = it.next() orelse return;
    const args = if (text.len > cmd.len + 2) text[cmd.len + 2 ..] else "";

    if (!global_state.isSudo(user_id)) {
        try bot.sendMessage(chat_id, UNAUTHORIZED_MSG, null);
        return;
    }

    if (std.mem.eql(u8, cmd, "help") or std.mem.eql(u8, cmd, "start")) {
        const help_text =
            \\╭─『 ⚡ 𝐕𝐈𝐋𝐋𝐀𝐈𝐍 𝐕𝐈𝐒𝐇𝐔 𝐆𝐄𝐍𝐎𝐒 𝐏𝐎𝐖𝐄𝐑𝐁𝐎𝐓 ⚡ 』─╮
            \\
            \\╭─ 𝐍𝐂 𝐌𝐎𝐃𝐄𝐒 (20+ MODES)
            \\│ • .genosnc <name>  • .timenc <name>
            \\│ • .vishunc <name>  • .villainnc <name>
            \\│ • .vvgnc <name>    • .ncemo <name>
            \\│ • .tmkcnc <name>   • .mcnc <name>
            \\│ • .😂nc <name>     • .😭nc <name>
            \\│ • .nc1..nc6 <name> • .fontnc <name>
            \\│ • .somaxchudnc     • .lndnc <name>
            \\│ • .alltextnc       • .ruk / .stopnc
            \\╰──────────────
            \\
            \\┌─ 𝐒𝐏𝐀𝐌 & 𝐒𝐖𝐈𝐏𝐄
            \\│ .spam <text>  •  .stopspam
            \\│ .swipe <text> •  .stopswipe
            \\└──────────────
            \\
            \\✦ 𝐒𝐘𝐒𝐓𝐄𝐌
            \\• .admin  • .add <token>  • .byy  • .status
            \\
            \\☠ 𝐒𝐔𝐃𝐎
            \\• .sudo  • .unsudo  • .listsudo  • .refresh
            \\
            \\╰─『 🔮 𝐙𝐈𝐆 𝐄𝐍𝐆𝐈𝐍𝐄 𝐕𝟓.𝟎 🔮 』─╯
        ;
        try bot.sendMessage(chat_id, help_text, null);
        return;
    }

    if (std.mem.eql(u8, cmd, "status") or std.mem.eql(u8, cmd, "stats")) {
        const up = time.timestamp() - global_state.start_time;
        const h = @divTrunc(up, 3600);
        const m = @divTrunc(@rem(up, 3600), 60);
        const s = @rem(up, 60);
        const metrics = getSystemMetrics();
        const msg = try std.fmt.allocPrint(bot.allocator,
            \\⚡ **ZIG BATTALION BOT STATUS**
            \\══════════════════════════════
            \\🤖 **Active Battalion:** `{d}` bots online
            \\⏱️ **Uptime:** `{d}h {d}m {d}s`
            \\🔄 **Total NC Executed:** `{d}`
            \\
            \\💾 **RAM RSS Footprint:** `{d:.2} MB`
            \\⚡ **Process CPU Load:** `{d:.1}%`
            \\══════════════════════════════
            \\✨ **Bare-Metal Zig Engine v0.11**
        , .{ global_state.battalion.items.len, h, m, s, global_state.nc_count.load(.Monotonic), metrics.ram_mb, metrics.cpu_percent });
        defer bot.allocator.free(msg);
        try bot.sendMessage(chat_id, msg, null);
        return;
    }

    if (std.mem.eql(u8, cmd, "ruk") or std.mem.eql(u8, cmd, "stopnc")) {
        global_state.stopNc(chat_id);
        try bot.sendMessage(chat_id, "🛑 **NC STOPPED**", null);
        return;
    }

    // NC Generator dispatcher
    var titles = std.ArrayList([]const u8).init(bot.allocator);
    var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
    const rng = prng.random();

    if (std.mem.eql(u8, cmd, "genosnc") or std.mem.eql(u8, cmd, "tmkcnc") or std.mem.eql(u8, cmd, "mcnc")) {
        const prefix_tag = if (std.mem.eql(u8, cmd, "tmkcnc")) " 𝐓𝐌𝐊𝐂" else if (std.mem.eql(u8, cmd, "mcnc")) " 𝒎𝒂𝒅𝒂𝒓𝒄𝒉𝒐𝒅 𝒓𝒏𝒅𝒚𝒌𝒆" else "";
        const pat_sym = if (std.mem.eql(u8, cmd, "tmkcnc")) "𒅒" else if (std.mem.eql(u8, cmd, "mcnc")) "⸻" else "꧅";
        for (0..30) |_| {
            const e = GENOSNC_EMOJIS[rng.uintLessThan(usize, GENOSNC_EMOJIS.len)];
            var p = std.ArrayList(u8).init(bot.allocator);
            for (0..45) |_| {
                try p.appendSlice(pat_sym);
                try p.appendSlice(e);
            }
            try p.appendSlice(pat_sym);
            const r = try std.fmt.allocPrint(bot.allocator, "{s}{s} {s}", .{ args, prefix_tag, p.items });
            p.deinit();
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🎀 **NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "timenc")) {
        for (0..30) |_| {
            const e1 = TIME_EMOJIS[rng.uintLessThan(usize, TIME_EMOJIS.len)];
            const e2 = TIME_EMOJIS[rng.uintLessThan(usize, TIME_EMOJIS.len)];
            const r = try std.fmt.allocPrint(bot.allocator, "{s} {s} {s} ﹝ZIG-CORE﹞", .{ e1, args, e2 });
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "⏱️ **TIME NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "vishunc")) {
        for (0..30) |_| {
            const w = VISHUNC_WORD[rng.uintLessThan(usize, VISHUNC_WORD.len)];
            const e = VISHU_EMOJIS[rng.uintLessThan(usize, VISHU_EMOJIS.len)];
            var p = std.ArrayList(u8).init(bot.allocator);
            for (0..50) |_| try p.appendSlice(e);
            const r = try std.fmt.allocPrint(bot.allocator, "{s} {s}{s}", .{ args, w, p.items });
            p.deinit();
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🩸 **VISHU NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "villainnc") or std.mem.eql(u8, cmd, "vvgnc")) {
        for (0..30) |idx| {
            const e = VILLAIN_EMOJIS[rng.uintLessThan(usize, VILLAIN_EMOJIS.len)];
            const r = try std.fmt.allocPrint(bot.allocator, "{s} 𓆩 ♡{s}♡ 𓆪 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐑ɴᴅɪ ~⚔️{d}", .{ e, args, idx + 1 });
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🏴‍☠️ **VILLAIN NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "ncemo") or std.mem.eql(u8, cmd, "😂nc") or std.mem.eql(u8, cmd, "😭nc")) {
        const pool = if (std.mem.eql(u8, cmd, "😂nc")) &FLAG_EMOJIS else if (std.mem.eql(u8, cmd, "😭nc")) &CRY_EMOJIS else &NCEMO_EMOJIS;
        for (0..30) |_| {
            const e1 = pool[rng.uintLessThan(usize, pool.len)];
            const e2 = pool[rng.uintLessThan(usize, pool.len)];
            const r = try std.fmt.allocPrint(bot.allocator, "{s} {s} {s}", .{ e1, args, e2 });
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🌸 **EMOJI NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "fontnc")) {
        const styled = try doubleStruck(bot.allocator, args);
        defer bot.allocator.free(styled);
        for (0..30) |_| {
            const e1 = GENOSNC_EMOJIS[rng.uintLessThan(usize, GENOSNC_EMOJIS.len)];
            const e2 = GENOSNC_EMOJIS[rng.uintLessThan(usize, GENOSNC_EMOJIS.len)];
            const r = try std.fmt.allocPrint(bot.allocator, "{s} {s} {s}", .{ e1, styled, e2 });
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "✨ **FONT NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "nc1") or std.mem.eql(u8, cmd, "nc2") or std.mem.eql(u8, cmd, "nc3") or std.mem.eql(u8, cmd, "nc4") or std.mem.eql(u8, cmd, "nc5") or std.mem.eql(u8, cmd, "nc6") or std.mem.eql(u8, cmd, "somaxchudnc") or std.mem.eql(u8, cmd, "lndnc") or std.mem.eql(u8, cmd, "alltextnc")) {
        for (0..30) |idx| {
            const e1 = ALL_EMOJIS[rng.uintLessThan(usize, ALL_EMOJIS.len)];
            const e2 = ALL_EMOJIS[rng.uintLessThan(usize, ALL_EMOJIS.len)];
            const c = CHUD_WORD[idx % CHUD_WORD.len];
            const r = try std.fmt.allocPrint(bot.allocator, "『 {s} 』{s} {s}『 {s} 』", .{ e1, args, c, e2 });
            try titles.append(truncTitle(r));
        }
        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🔥 **NC LOOP STARTED**", null);
        return;
    }

    // Spam & Swipe
    if (std.mem.eql(u8, cmd, "spam")) {
        global_state.stopSpam(chat_id);
        const flag = try global_state.allocator.create(Atomic(bool));
        flag.* = Atomic(bool).init(true);
        global_state.mutex.lock();
        try global_state.active_spam.put(chat_id, flag);
        const bots_copy = try global_state.battalion.clone();
        global_state.mutex.unlock();
        defer bots_copy.deinit();

        const msg_to_send = if (args.len > 0) args else SPAM_DEFAULT_MSGS[0];
        for (bots_copy.items) |b| {
            const Runner = struct {
                fn run(bp: *BotClient, cid: i64, txt: []const u8, fp: *Atomic(bool)) void {
                    while (fp.load(.Monotonic)) {
                        bp.sendMessage(cid, txt, null) catch {};
                        time.sleep(50 * time.ns_per_ms);
                    }
                }
            };
            const h = try Thread.spawn(.{}, Runner.run, .{ b, chat_id, msg_to_send, flag });
            h.detach();
        }
        try bot.sendMessage(chat_id, "🚀 **SPAM STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "stopspam")) {
        global_state.stopSpam(chat_id);
        try bot.sendMessage(chat_id, "🛑 **SPAM STOPPED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "swipe")) {
        global_state.stopSwipe(chat_id);
        const flag = try global_state.allocator.create(Atomic(bool));
        flag.* = Atomic(bool).init(true);
        global_state.mutex.lock();
        try global_state.active_swipe.put(chat_id, flag);
        const bots_copy = try global_state.battalion.clone();
        global_state.mutex.unlock();
        defer bots_copy.deinit();

        for (bots_copy.items) |b| {
            const Runner = struct {
                fn run(bp: *BotClient, cid: i64, fp: *Atomic(bool)) void {
                    var p = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
                    while (fp.load(.Monotonic)) {
                        const txt = SWIPE_MSGS[p.random().uintLessThan(usize, SWIPE_MSGS.len)];
                        bp.sendMessage(cid, txt, null) catch {};
                        time.sleep(100 * time.ns_per_ms);
                    }
                }
            };
            const h = try Thread.spawn(.{}, Runner.run, .{ b, chat_id, flag });
            h.detach();
        }
        try bot.sendMessage(chat_id, "🔄 **SWIPE STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "stopswipe")) {
        global_state.stopSwipe(chat_id);
        try bot.sendMessage(chat_id, "🛑 **SWIPE STOPPED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "admin")) {
        global_state.mutex.lock();
        const bots_copy = try global_state.battalion.clone();
        global_state.mutex.unlock();
        defer bots_copy.deinit();
        var promoted: usize = 0;
        for (bots_copy.items) |b| {
            if (b.id != 0) {
                b.promoteAdmin(chat_id, b.id) catch continue;
                promoted += 1;
            }
        }
        const resp = try std.fmt.allocPrint(bot.allocator, "✅ `{d}` bots promoted!", .{promoted});
        defer bot.allocator.free(resp);
        try bot.sendMessage(chat_id, resp, null);
        return;
    }

    if (std.mem.eql(u8, cmd, "byy") or std.mem.eql(u8, cmd, "leavegc")) {
        global_state.stopNc(chat_id);
        global_state.stopSpam(chat_id);
        global_state.stopSwipe(chat_id);
        try bot.sendMessage(chat_id, "Leaving... 🕊️", null);
        global_state.mutex.lock();
        const bots_copy = try global_state.battalion.clone();
        global_state.mutex.unlock();
        defer bots_copy.deinit();
        for (bots_copy.items) |b| b.leaveChat(chat_id) catch {};
        return;
    }

    if (std.mem.eql(u8, cmd, "sudo") and user_id == OWNER_ID) {
        if (reply_user_id) |target| {
            try global_state.sudo_set.put(target, {});
            try bot.sendMessage(chat_id, "✅ Added to sudo.", null);
        }
        return;
    }

    if (std.mem.eql(u8, cmd, "unsudo") and user_id == OWNER_ID) {
        if (reply_user_id) |target| {
            _ = global_state.sudo_set.remove(target);
            try bot.sendMessage(chat_id, "✅ Removed from sudo.", null);
        }
        return;
    }
}

// ── Polling Thread ──
pub fn botPollingThread(bot: *BotClient) void {
    var offset: i64 = 0;
    while (true) {
        var payload = std.ArrayList(u8).init(bot.allocator);
        std.json.stringify(.{ .offset = offset, .timeout = 25, .allowed_updates = [_][]const u8{"message"} }, .{}, payload.writer()) catch continue;
        const res = bot.makeApiCall("getUpdates", payload.items) catch {
            time.sleep(3 * time.ns_per_s);
            payload.deinit();
            continue;
        };
        payload.deinit();

        var parsed = std.json.parseFromSlice(std.json.Value, bot.allocator, res, .{}) catch {
            bot.allocator.free(res);
            continue;
        };

        if (parsed.value.object.get("result")) |res_arr| {
            if (res_arr == .array) {
                for (res_arr.array.items) |upd| {
                    offset = upd.object.get("update_id").?.integer + 1;
                    if (upd.object.get("message")) |msg_obj| {
                        const msg = msg_obj.object;
                        const chat_id = msg.get("chat").?.object.get("id").?.integer;
                        const user_id = if (msg.get("from")) |f| f.object.get("id").?.integer else 0;
                        const text = if (msg.get("text")) |t| t.string else "";
                        var rep_uid: ?i64 = null;
                        if (msg.get("reply_to_message")) |rep| {
                            if (rep.object.get("from")) |rf| rep_uid = rf.object.get("id").?.integer;
                        }
                        if (bot.is_leader) handleCommand(bot, chat_id, user_id, text, rep_uid) catch {};
                    }
                }
            }
        }
        parsed.deinit();
        bot.allocator.free(res);
    }
}

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    global_state = GlobalState.init(allocator);
    try global_state.sudo_set.put(OWNER_ID, {});

    std.debug.print("\n⚡ BATTALION DARK CORE v5.0 (ZIG 0.11) ⚡\n[+] Target RAM Usage: < 2.5 MB\n", .{});

    var is_first: bool = true;
    for (INITIAL_BOT_TOKENS) |token| {
        const bot = try allocator.create(BotClient);
        bot.* = BotClient.init(allocator, token, is_first);
        is_first = false;

        if (bot.fetchMe() catch false) {
            std.debug.print("  [+] Bot Connected: @{s} (ID: {d}) | Leader: {}\n", .{ bot.username, bot.id, bot.is_leader });
            try global_state.battalion.append(bot);
            const handle = try Thread.spawn(.{}, botPollingThread, .{bot});
            handle.detach();
        }
    }

    std.debug.print("  ⚡ ACTIVE BATTALION: {d} BOTS ONLINE ⚡\n", .{global_state.battalion.items.len});

    while (true) {
        time.sleep(60 * time.ns_per_s);
    }
}
