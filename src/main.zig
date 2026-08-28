const std = @import("std");
const os = std.os;
const time = std.time;
const heap = std.heap;
const Thread = std.Thread;
const Atomic = std.atomic.Atomic;

// ══════════════════════════════════════════════════════════════════════════════
//  CONFIGURATION CONSTANTS
// ══════════════════════════════════════════════════════════════════════════════
pub const OWNER_ID: i64 = 8817232625;
pub const SUDO_FILE = "sudo.json";
pub const GENOS_FILE = "nc_bots.json";
pub const CMD_PREFIX: u8 = '.';

pub const INITIAL_BOT_TOKENS = [_][]const u8{
    "8743415286:AAFEUhvxJCa8WhlvYzXAIZQ7g3pi8OrH6ik",
};

pub const UNAUTHORIZED_MSG = "𝘊𝘏𝘓 𝘙𝘕𝘋𝘠𝘒𝘌 𝘝𝘐𝘓𝘓𝘈𝘐𝘕 𝘝𝘐𝘚𝘏𝘜 𝘎𝘌𝘕𝘖𝘚 𝘒𝘈 𝘓𝘕𝘋 𝘊𝘏𝘜𝘚 𝘗𝘏𝘓𝘌💥";

// ══════════════════════════════════════════════════════════════════════════════
//  DATA POOLS
// ══════════════════════════════════════════════════════════════════════════════
pub const GENOSNC_EMOJIS = [_][]const u8{
    "🎀", "🌸", "💮", "🪷", "🏵️", "🌹", "🥀", "🌺", "🌻", "🌼",
    "🌷", "🪻", "⚜️", "🍀", "☘️", "🌿", "🍃", "🍂", "🍁", "🌱",
    "🌾", "🌵", "🪴", "✨", "💫", "⭐", "🌟", "🌙", "🧿", "🔮",
    "🦋", "🕊️", "🎧", "🎭", "🕯️", "🫧", "🪶", "💖", "💗", "💓",
};

pub const TIME_EMOJIS = [_][]const u8{
    "⏱️", "⏰", "⌛", "⏳", "🕐", "🕒", "🕔", "🕖", "🕘", "🕚", "⚡", "✨", "💫",
};

pub const VISHU_EMOJIS = [_][]const u8{
    "🍡", "㊗️", "🕷️", "🚗", "🩸", "🦠", "💐", "🌇", "🔥", "⚡",
    "💥", "☠️", "💀", "🖤", "🌑", "🔱", "⚔️", "🌀", "🌩️", "✨",
    "💫", "🌙", "⭐", "🦋", "🫧", "🌸", "🕊️", "🔮", "🧿", "🪶",
    "🎭", "🎧", "🕯️", "🥀", "🌹", "👑", "💎", "🎯", "🎲", "♠️",
};

pub const VISHUNC_WORD = [_][]const u8{
    "2-3 ⱮƛӇƖƝЄ ӇƲЄ ƝƛӇƖ ӇƛƓƝЄ ԼƓЄ ???? 🤣",
    "ⱦєяє ɠɦαя кι αυятση кι вяα ƒαα∂ к αρηα кυятα ѕιℓωαυ яη∂ук ???? 🤣",
    "ƓƦƖƁ Ɱƛ Ƙ ƁƛƇӇƳ ƓӇƛƦ ⱮЄ ƛƬƬƛ ԼЄ ƛƛ ???? 🤣",
    "ƊӇƛƬ яη∂ιкєу ???? 🤣",
    "ƬЄƦƖ Ɱƛƛ Ƙƛ ƁӇƧƊƛ ???? 🤣",
    "Ƭєяι мα к вσѕ∂є м αιѕα ℓαт мαяυggα ηα gαтє ωαу σƒ ιη∂ια вαη נαєggα ???? 🤣",
    "ꪶ  ⱠƲƝ ƬЄ Ɣƛʝ ꪻ♡︎ ???? 🤣",
    "уααя αρηι мα мт ηυηgу кя ???? 🤣",
    "Ƭяу мσм кє ѕαтн вα∂ мαηηєяѕ кя∂υggα ???? 🤣",
    "ƬЄƦƖ Ɱƛ ƇӇƠƊƲƝ ???? 🤣",
    "ƬЄƦƖ Ɱƛ Ƙ ƁӇƠƧƊƛ ⱮƛƊƦƇӇƠƊ ???? 🤣",
    "ⱮƛƇƇӇƛƦ ƬⱮƘƇ ???? 🤣",
    "Ƭєяу мαα кσ qαвαяα ηαѕєєв ηα нσ яη∂укє ???? 🤣",
    "ƲƬӇ яη∂к кυттє ???? 🤣",
    "ƤƛƦԼЄ Ɠ ƘӇƛЄƓƛ ƘƳƛ ƬƠⱮⱮƳ ???? 🤣",
    "ƁƖӇƛƦƖ ƓƛƝƓ ƬЄƦƖ Ɱƛ ƇӇƠƊƲƝ ???? 🤣",
    "ƬƲⱮ ƧƁ ƘƲƬƬƠ ƘƖ ʝӇƲƝƊ ƘƖ ⱮƘƁ ???? 🤣",
    "ƓƇ ԼЄƑƬ ԼЄ яη∂ιвαℓα ???? 🤣",
    "Ƭєяι мαα кι ƈнσтι ραкα∂ кє ∂єєωαя мє мααяυηgα ∂нαм ∂нαм кι αωααנ ααуєgι ???? 🤣",
    "ƁӇƛƓƝƛ ⱮƛƝƛ ӇƳ ƬⱮƘƁ ???? 🤣",
    "ƘƖ ⱮƘƁ ƳƦƦ ƁӇƛƓ ƘЄƧЄ ƦӇЄ ӇƠ ƓƛƦƖƁƠ ???? 🤣",
    "ƬⱮƘƇ ???? 🤣",
    "ƬⱮƘƁ ???? 🤣",
    "ƬƁƘƇ ???? 🤣",
    "ƦƝƊƘ ƁƛƇӇƳ ???? 🤣",
    "ƠƳЄ ƬƠⱮⱮƳ ƲƬӇ ƁӇƛƓƝƛ ƝƳ ӇƛƖ ???? 🤣",
};

pub const FLAG_EMOJIS = [_][]const u8{
    "🏁", "🚩", "🎌", "🏴", "🏳️", "🇦🇫", "🇦🇱", "🇩🇿", "🇦🇷", "🇦🇲", "🇦🇺", "🇦🇹",
    "🇧🇩", "🇧🇪", "🇧🇷", "🇨🇦", "🇨🇳", "🇨🇴", "🇩🇰", "🇪🇬", "🇫🇷", "🇩🇪", "🇬🇷", "🇮🇳",
    "🇮🇩", "🇮🇷", "🇮🇶", "🇮🇹", "🇯🇵", "🇰🇷", "🇲🇾", "🇲🇽", "🇳🇵", "🇳🇱", "🇳🇿", "🇳🇬",
    "🇵🇰", "🇵🇭", "🇵🇱", "🇵🇹", "🇷🇺", "🇸🇦", "🇸🇬", "🇿🇦", "🇪🇸", "🇸🇪", "🇨🇭", "🇹🇷",
    "🇦🇪", "🇬🇧", "🇺🇸", "🇻🇳",
};

pub const NCEMO_EMOJIS = [_][]const u8{
    "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "🥲", "🥹", "☺️", "😊",
    "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", "😋",
    "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🥸", "🤩", "🥳", "😏",
    "😒", "😞", "😔", "😟", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "🥺",
    "😢", "😭", "😮‍💨", "😤", "😠", "😡", "🤬", "🤯", "😳", "🥵", "🥶", "😱",
};

pub const HEART_EMOJIS = [_][]const u8{
    "💖", "💗", "💓", "💞", "💕", "❤️", "🖤", "🩵",
    "💜", "💙", "💚", "💛", "🧡", "🤍", "🪶", "❣️",
};

pub const VILLAIN_EMOJIS = [_][]const u8{
    "🏴‍☠️", "☠️", "💀", "👿", "👺", "🩸", "🔪", "⚔️",
    "👑", "🇦🇨", "⚡", "🔥", "💥", "🔱", "⛓️", "🖤",
};

pub const CRY_EMOJIS = [_][]const u8{
    "😭", "💔", "🥺", "🥹", "😢", "😞", "😔", "😿", "🫂", "🤍",
    "🌧️", "❄️", "🌊", "💧", "🫧", "☁️", "🕊️", "🪽", "🌺", "🌸",
};

pub const NC5_EMOJIS = [_][]const u8{
    " 🅱🅻🅾🅾🅳🆈 🅷🅴🅻🅻.𖥔 ݁ ˖ִ🛸༄˖°.",
    " 🅼🅾🆃🅷🅴🆁🅵🆄🅲🅺🅴🆁🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧",
    " 🅱🅸🆃🅲🅷 🆂🅾🅽.𖥔 ݁ ˖ִ🛸༄˖°.",
    "🆂🅻🅰🆅🅴🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧",
    " 🆂🅾🅽 🅾🅵 🅼🅸🅰 🅺🅷🅰🅻🅸🅵🅰 .𖥔 ݁ ˖ִ🛸༄˖°.",
    "🆂🅰🆈 🅶🅴🅽🅾🆂 🅳🅰🅳🅳🆈🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧",
    "🅵🆄🅲🅺🅽🄶 🅲🅴🅽🆃🆁🅴.𖥔 ݁ ˖ִ🛸༄˖°.",
    " 🆂🅾🅽 🅵🆄🅲🅺🅴🅳 🅼🅾🅼🌊⋆｡ 𖦹°.🐚⋆❀˖°🫧",
};

pub const RND_EMOJI = [_][]const u8{
    "🦋⃟🌑", "🦋⃟🌒", "🦋⃟🌔", "🦋⃟🌕", "🦋⃟🌖", "🦋⃟🌗", "🦋⃟🌘", "🦋⃟🪐",
    "⚡⃟🌑", "⚡⃟🌒", "⚡⃟🌔", "⚡⃟🌕", "⚡⃟🌖", "⚡⃟🌗", "⚡⃟🌘", "⚡⃟🪐",
    "🔥⃟🌑", "🔥⃟🌒", "🔥⃟🌔", "🔥⃟🌕", "🔥⃟🌖", "🔥⃟🌗", "🔥⃟🌘", "🔥⃟🪐",
    "🪐⃟🌑", "🪐⃟🌒", "🪐⃟🌔", "🪐⃟🌕", "🪐⃟🌖", "🪐⃟🌗", "🪐⃟🌘", "🪐⃟🪐",
    "💀⃟🌑", "💀⃟🌒", "💀⃟🌔", "💀⃟🌕", "💀⃟🌖", "💀⃟🌗", "💀⃟🌘", "💀⃟🪐",
};

pub const ALL_EMOJIS = [_][]const u8{
    "💯", "💢", "💥", "💫", "💦", "💨", "🕳️", "💣", "💬", "🗨️", "🗯️", "💭", "💤", "👋", "👌", "✌️", "🤞", "🤟", "🤘", "🤙", "👍", "👎", "✊", "👊", "👏", "🙌", "🫶", "👐", "🤲", "🤝", "🙏", "💪", "🧠", "👀", "👁️", "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐦", "🐤", "🦆", "🦅", "🦉", "🦇", "🐺", "🐗", "🐴", "🦄", "🐝", "🐛", "🦋", "🐌", "🐞", "🕷️", "🕸️", "🦂", "🐢", "🐍", "🦎", "🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🦈", "🐊", "🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🐪", "🦒", "🦘", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🐑", "🐐", "🦌", "🐕", "🐈", "🐓", "🦃", "🕊️", "🐇", "🐾", "🐉", "🐲", "🌵", "🎄", "🌲", "🌳", "🌴", "🌱", "🌿", "☘️", "🍀", "🍃", "🍂", "🍁", "🍄", "🌾", "💐", "🌷", "🌹", "🥀", "🪻", "🌺", "🌸", "🌼", "🌻", "🌞", "🌝", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔", "🌙", "🌎", "🪐", "💫", "⭐️", "🌟", "✨", "⚡️", "☄️", "💥", "🔥", "🌪️", "🌈", "☀️", "🌧️", "🌨️", "❄️", "☃️", "💨", "💧", "🫧", "🌊", "🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🥑", "🥦", "🌶️", "🌽", "🥕", "🥐", "🍞", "🧀", "🍳", "🥞", "🍔", "🍟", "🍕", "🌭", "🥪", "🌮", "🌯", "🥗", "🍝", "🍜", "🍣", "🍦", "🎂", "🧁", "🍫", "🍿", "🍩", "🍪", "☕️", "🍵", "🧃", "🍺", "🍷", "🍾", "⚽️", "🏀", "🏈", "🎾", "🏐", "🎱", "🏓", "🏸", "🥊", "🥋", "🏆", "🥇", "🥈", "🥉", "🎫", "🎟️", "🎭", "🎨", "🎬", "🎤", "🎧", "🎼", "🎹", "🥁", "🎷", "🎺", "🎸", "🎻", "🎲", "♟️", "🎯", "🎳", "🎮", "🚗", "🚕", "🏎️", "🚑", "🚓", "✈️", "🚀", "🛸", "⛵️", "🚢", "⛽️", "🚦", "🛑", "🔔", "📢", "📣", "♠️", "♣️", "♥️", "♦️", "🃏", "⚠️", "⛔️", "🚫", "🔞", "☢️", "☣️", "⬆️", "➡️", "⬇️", "⬅️", "🔄", "🎵", "🎶", "➕", "➖", "✖️", "♾️", "💲", "❌", "⭕️", "❗", "❕", "❓",
};

pub const RNDYKE_CHUD = [_][]const u8{
    "✫𝖡ꪮ𝗌ᴅɪᴋᴇ＼＼",
    "✫𝖱ɴᴅɪ＼＼",
    "✫𝖢ʜᴜᴅꪖɪ 𝖪ʜꪖ＼＼",
    "✫𝖢ʜꪖᴍᴀʀ＼＼",
    "✫𝖡ꪮʟ ꪜɪʟʟꪖɪɴ 𝖵ɪ𝗌ʜᴜ 𝖦ꫀɴꪮ𝗌 𝖯ꪖᴘᴀ 𝖧ꫀʟᴘ 𝖬ꫀꫀꫀ＼＼",
    "𝖬ꪖᴅꫀʀᴄʜꪮᴅ＼＼",
    "𝖳ꫀʀɪ 𝖬ꪖꪖ 𝖪ꪖ 𝖡ʜꪮ𝗌ᴅᴀ＼＼",
    "𝖲ᴄʀɪᴘᴛ 𝖣ᴜɴ 𝖦ᴀʀᴇᴇʙ＼＼",
    "𝖱ꪖɴᴅʏᴋᴇ 𝖡ᴄʜᴇ＼＼",
};

pub const CHUD_WORD = [_][]const u8{
    "कमजोर रण्डी 🩶᭪", "कमजोर रण्डी 🩵᭪", "कमजोर रण्डी 🩷᭪", "कमजोर रण्डी 🤍᭪",
    "TERI बहन KI BRA 👙", "TERI माँ KI BRA 👙", "TERI दादी KI BRA 👙",
    "𝘛𝘈𝘛𝘛𝘌💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "𝘙𝘕𝘋 💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "𝘛𝘔𝘒𝘉💝𓂃 ࣪˖ ִֶཐི༏ཋྀ", "𝘓𝘈𝘕𝘋 𝘓𝘌💝𓂃 ࣪˖ ִֶཐི༏ཋྀ",
    "चुद पुत्र ִֶ 𓂃🏴‍☠️⊹", "चुद पुत्रˑ ִֶ 𓂃🇦🇱⊹", "चुद पुत्रˑ ִֶ 𓂃🇦🇫⊹",
    "तू लंड पे(🍂)ᝰ.ᐟ", "रण्डी(🍂)ᝰ.ᐟ", "चक्का(🍂)ᝰ.ᐟ", "सुआर(🍂)ᝰ.ᐟ",
};

pub const SPAM_DEFAULT_MSGS = [_][]const u8{
    " ོ༘₊⁺🇮🇳 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐈ɴᴅɪᴀ 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇮🇳 ₊⁺⋆.˚",
    " ོ༘₊⁺🇯🇵 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐉ᴀᴘᴀɴ 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇯🇵 ₊⁺⋆. ",
    " ₊⁺🇺🇸 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐔𝐒𝐀 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇺🇸 ₊⁺⋆.˚",
    " ོ༘₊⁺🇬🇧 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐔𝐊 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇬🇧 ₊⁺⋆.˚",
    " ོ༘₊⁺🇰🇷 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐊ᴏʀᴇᴀ 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇰🇷 ₊⁺⋆.˚",
    " ོ༘₊⁺🇩🇪 ₊⁺⋆.˚ 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐊ᴇ 𝐒ᴀ𝐓ʜ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐁ᴀᴀᴘ 𝐀ᴜʀ 𝐆ᴇʀᴍᴀɴ𝐘 𝐖ᴀʟᴇ 𝐁ʜɪ 𝐂ʜɪʟʟ 𝐊ᴀʀ 𝐑ʜᴇ ོ༘₊⁺🇩🇪 ₊⁺⋆.˚",
};

pub const SWIPE_MSGS = [_][]const u8{
    "𝐊ʏᴀ 𝐑ᴇ 𝐑ᴀɴᴅɪᴋᴇ 𝐂ᴏᴏʟ 𝐁ᴀɴᴇɢᴀ 𝐓ᴜ 𝐂ʜᴀʟ 𝐀ʙ 𝐂ʜᴜᴅ 𝐀ᴘɴᴇ 𝐁ᴀᴀᴘ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐒ᴇ - 🦢💘",
    "𝐊ɪ 𝐌ᴀᴀ 𝐌ᴀʀʀ 𝐆ᴀʏɪ 𝐘ᴀᴀʀ - 𝐉ᴀɪ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs ! 🌙",
    "acha beta 😂🔥👊🏻 ? coi na me toh HATER codunga 😹💔🔥😆👊🏻💥",
    "chudke bhaga kaise 😂💥🤣🤘🏻",
    "ne toh 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs ka lun muh me lelia 😂🙏🏻😂🙏🏻",
    "try maa सूर्य☀ nikalte hi pel du 😹🔥💔",
    "mkl lun te vaj 😂✊🏻💦",
    "𝗧ᴍᴋ𝗕 pe 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs ka hamla 😂⚔🔥💥",
};

// ══════════════════════════════════════════════════════════════════════════════
//  SYSTEM HARDWARE TELEMETRY
// ══════════════════════════════════════════════════════════════════════════════
pub const SystemMetrics = struct {
    ram_mb: f64,
    cpu_percent: f64,
};

var prev_cpu_time: u64 = 0;
var prev_sample_time: i64 = 0;

pub fn getSystemMetrics() SystemMetrics {
    var ram_mb: f64 = 0.0;
    var cpu_percent: f64 = 0.0;

    // 1. RSS Memory from /proc/self/statm
    if (std.fs.cwd().openFile("/proc/self/statm", .{})) |file| {
        defer file.close();
        var buf: [128]u8 = undefined;
        if (file.readAll(&buf)) |bytes_read| {
            var it = std.mem.tokenizeScalar(u8, buf[0..bytes_read], ' ');
            _ = it.next();
            if (it.next()) |res_str| {
                if (std.fmt.parseInt(u64, res_str, 10)) |pages| {
                    ram_mb = (@as(f64, @floatFromInt(pages)) * 4096.0) / (1024.0 * 1024.0);
                } else |_| {}
            }
        } else |_| {}
    } else |_| {}

    // 2. CPU load from /proc/self/stat
    if (std.fs.cwd().openFile("/proc/self/stat", .{})) |file| {
        defer file.close();
        var buf: [1024]u8 = undefined;
        if (file.readAll(&buf)) |bytes_read| {
            var it = std.mem.tokenizeScalar(u8, buf[0..bytes_read], ' ');
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
                cpu_percent = (d_ticks / 100.0) / dt * 100.0;
                if (cpu_percent > 100.0) cpu_percent = 100.0;
                if (cpu_percent < 0.0) cpu_percent = 0.0;
            }
            prev_cpu_time = total;
            prev_sample_time = now;
        } else |_| {}
    } else |_| {}

    return .{ .ram_mb = ram_mb, .cpu_percent = cpu_percent };
}

// ══════════════════════════════════════════════════════════════════════════════
//  STRING UTILS & DOUBLE STRUCK FONT
// ══════════════════════════════════════════════════════════════════════════════
pub fn truncTitle(raw: []const u8) []const u8 {
    if (raw.len <= 255) return raw;
    var cut: usize = 255;
    while (cut > 0 and (raw[cut] & 0xC0) == 0x80) {
        cut -= 1;
    }
    return raw[0..cut];
}

pub fn doubleStruck(allocator: std.mem.Allocator, text: []const u8) ![]u8 {
    var out = std.ArrayList(u8).init(allocator);
    for (text) |c| {
        if (c >= 'A' and c <= 'Z') {
            const cp: u32 = 0x1D538 + (c - 'A');
            var buf: [4]u8 = undefined;
            const len = try std.unicode.utf8Encode(@intCast(cp), &buf);
            try out.appendSlice(buf[0..len]);
        } else if (c >= 'a' and c <= 'z') {
            const cp: u32 = 0x1D552 + (c - 'a');
            var buf: [4]u8 = undefined;
            const len = try std.unicode.utf8Encode(@intCast(cp), &buf);
            try out.appendSlice(buf[0..len]);
        } else if (c >= '0' and c <= '9') {
            const cp: u32 = 0x1D7D8 + (c - '0');
            var buf: [4]u8 = undefined;
            const len = try std.unicode.utf8Encode(@intCast(cp), &buf);
            try out.appendSlice(buf[0..len]);
        } else {
            try out.append(c);
        }
    }
    return out.toOwnedSlice();
}

// ══════════════════════════════════════════════════════════════════════════════
//  TELEGRAM API CLIENT
// ══════════════════════════════════════════════════════════════════════════════
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
        var req = try client.request(.POST, uri, .{ .allocator = self.allocator }, .{});
        defer req.deinit();

        req.headers.content_type = .{ .override = "application/json" };
        try req.start();
        try req.writeAll(json_payload);
        try req.finish();
        try req.wait();

        var reader = req.reader();
        return try reader.readAllAlloc(self.allocator, 1024 * 1024);
    }

    pub fn sendMessage(self: *BotClient, chat_id: i64, text: []const u8, reply_to: ?i64) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();

        if (reply_to) |rep| {
            try std.json.stringify(.{
                .chat_id = chat_id,
                .text = text,
                .reply_to_message_id = rep,
            }, .{}, json_buf.writer());
        } else {
            try std.json.stringify(.{
                .chat_id = chat_id,
                .text = text,
            }, .{}, json_buf.writer());
        }

        const res = try self.makeApiCall("sendMessage", json_buf.items);
        self.allocator.free(res);
    }

    pub fn setChatTitle(self: *BotClient, chat_id: i64, title: []const u8) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();

        try std.json.stringify(.{
            .chat_id = chat_id,
            .title = title,
        }, .{}, json_buf.writer());

        const res = try self.makeApiCall("setChatTitle", json_buf.items);
        self.allocator.free(res);
    }

    pub fn promoteAdmin(self: *BotClient, chat_id: i64, user_id: i64) !void {
        var json_buf = std.ArrayList(u8).init(self.allocator);
        defer json_buf.deinit();

        try std.json.stringify(.{
            .chat_id = chat_id,
            .user_id = user_id,
            .can_change_info = true,
            .can_post_messages = true,
            .can_edit_messages = true,
            .can_delete_messages = true,
            .can_invite_users = true,
            .can_restrict_members = true,
            .can_pin_messages = true,
            .can_promote_members = true,
            .can_manage_chat = true,
            .can_manage_video_chats = true,
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

        if (parsed.value.object.get("ok")) |ok_val| {
            if (ok_val.bool) {
                const result = parsed.value.object.get("result").?.object;
                self.id = result.get("id").?.integer;
                if (result.get("username")) |un| {
                    self.username = try self.allocator.dupe(u8, un.string);
                }
                return true;
            }
        }
        return false;
    }
};

// ══════════════════════════════════════════════════════════════════════════════
//  GLOBAL STATE
// ══════════════════════════════════════════════════════════════════════════════
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

    pub fn addSudo(self: *GlobalState, uid: i64) !void {
        self.mutex.lock();
        defer self.mutex.unlock();
        try self.sudo_set.put(uid, {});
        self.saveSudo();
    }

    pub fn removeSudo(self: *GlobalState, uid: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        _ = self.sudo_set.remove(uid);
        self.saveSudo();
    }

    pub fn loadSudo(self: *GlobalState) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        self.sudo_set.put(OWNER_ID, {}) catch {};

        if (std.fs.cwd().openFile(SUDO_FILE, .{})) |file| {
            defer file.close();
            var buf: [4096]u8 = undefined;
            if (file.readAll(&buf)) |len| {
                var parsed = std.json.parseFromSlice(std.json.Value, self.allocator, buf[0..len], .{}) catch return;
                defer parsed.deinit();
                if (parsed.value == .array) {
                    for (parsed.value.array.items) |item| {
                        if (item == .integer) {
                            self.sudo_set.put(item.integer, {}) catch {};
                        }
                    }
                }
            } else |_| {}
        } else |_| {}
    }

    pub fn saveSudo(self: *GlobalState) void {
        if (std.fs.cwd().createFile(SUDO_FILE, .{})) |file| {
            defer file.close();
            var list = std.ArrayList(i64).init(self.allocator);
            defer list.deinit();

            var it = self.sudo_set.keyIterator();
            while (it.next()) |k| {
                list.append(k.*) catch {};
            }

            var string = std.ArrayList(u8).init(self.allocator);
            defer string.deinit();
            std.json.stringify(list.items, .{}, string.writer()) catch return;
            file.writeAll(string.items) catch return;
        } else |_| {}
    }

    pub fn stopNc(self: *GlobalState, chat_id: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if (self.active_nc.get(chat_id)) |flag| {
            flag.store(false, .monotonic);
        }
    }

    pub fn stopSpam(self: *GlobalState, chat_id: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if (self.active_spam.get(chat_id)) |flag| {
            flag.store(false, .monotonic);
        }
    }

    pub fn stopSwipe(self: *GlobalState, chat_id: i64) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if (self.active_swipe.get(chat_id)) |flag| {
            flag.store(false, .monotonic);
        }
    }
};

var global_state: GlobalState = undefined;

// ══════════════════════════════════════════════════════════════════════════════
//  NC WORKER & CONCURRENCY
// ══════════════════════════════════════════════════════════════════════════════
const NcWorkerContext = struct {
    bot: *BotClient,
    chat_id: i64,
    titles: [][]const u8,
    flag: *Atomic(bool),
};

fn ncWorkerThread(ctx: NcWorkerContext) void {
    var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
    const random = prng.random();

    while (ctx.flag.load(.monotonic)) {
        const title_idx = random.uintLessThan(usize, ctx.titles.len);
        const title = ctx.titles[title_idx];

        ctx.bot.setChatTitle(ctx.chat_id, title) catch {
            time.sleep(100 * time.ns_per_ms);
            continue;
        };

        _ = global_state.nc_count.fetchAdd(1, .monotonic);
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
        const thread_ctx = NcWorkerContext{
            .bot = bot,
            .chat_id = chat_id,
            .titles = titles,
            .flag = flag,
        };
        const handle = try Thread.spawn(.{}, ncWorkerThread, .{thread_ctx});
        handle.detach();
    }
}

// ══════════════════════════════════════════════════════════════════════════════
//  COMMAND DISPATCHER
// ══════════════════════════════════════════════════════════════════════════════
pub fn handleCommand(bot: *BotClient, chat_id: i64, user_id: i64, text: []const u8, reply_user_id: ?i64) !void {
    if (text.len == 0 or text[0] != CMD_PREFIX) return;

    var it = std.mem.tokenizeScalar(u8, text[1..], ' ');
    const cmd = it.next() orelse return;
    const args = if (text.len > cmd.len + 2) text[cmd.len + 2 ..] else "";

    if (!global_state.isSudo(user_id)) {
        try bot.sendMessage(chat_id, UNAUTHORIZED_MSG, null);
        return;
    }

    // ────────────────────────── 1. HELP / MENU ──────────────────────────
    if (std.mem.eql(u8, cmd, "help") or std.mem.eql(u8, cmd, "start")) {
        const help_text =
            \\╭─『 ⚡ 𝐕𝐈𝐋𝐋𝐀𝐈𝐍 𝐕𝐈𝐒𝐇𝐔 𝐆𝐄𝐍𝐎𝐒 𝐏𝐎𝐖𝐄𝐑𝐁𝐎𝐓 ⚡ 』─╮
            \\
            \\╭─ 𝐍𝐂 𝐌𝐎𝐃𝐄𝐒
            \\│ • .genosnc <name>
            \\│ • .timenc <name>
            \\│ • .vishunc <name>
            \\│ • .villainnc <name>
            \\│ • .vvgnc <name>
            \\│ • .tmkcnc <name>
            \\│ • .mcnc <name>
            \\│ • .😂nc <name>
            \\│ • .😭nc <name>
            \\│ • .nc1 <name>
            \\│ • .nc2 <name>
            \\│ • .nc3 <name>
            \\│ • .nc4 <name>
            \\│ • .nc5 <name>
            \\│ • .nc6 <name>
            \\│ • .fontnc <name>
            \\│ • .somaxchudnc <name>
            \\│ • .lndnc <name>
            \\│ • .alltextnc <name>
            \\│ • .ruk  • .stopnc
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

    // ────────────────────────── 2. STATUS TELEMETRY ──────────────────────────
    if (std.mem.eql(u8, cmd, "status") or std.mem.eql(u8, cmd, "stats")) {
        const uptime = time.timestamp() - global_state.start_time;
        const h = @divTrunc(uptime, 3600);
        const m = @divTrunc(@rem(uptime, 3600), 60);
        const s = @rem(uptime, 60);
        const metrics = getSystemMetrics();

        global_state.mutex.lock();
        const bot_count = global_state.battalion.items.len;
        var active_nc_count: usize = 0;
        var it_nc = global_state.active_nc.valueIterator();
        while (it_nc.next()) |flag| {
            if (flag.*.load(.monotonic)) active_nc_count += 1;
        }
        global_state.mutex.unlock();

        const status_msg = try std.fmt.allocPrint(bot.allocator,
            \\⚡ **ZIG BATTALION BOT STATUS**
            \\══════════════════════════════
            \\🤖 **Active Battalion:** `{d}` bots online
            \\⏱️ **Uptime:** `{d}h {d}m {d}s`
            \\🔄 **Total NC Executed:** `{d}`
            \\🚀 **Active NC Tasks:** `{d}` chats
            \\
            \\💾 **RAM RSS Footprint:** `{d:.2} MB`
            \\⚡ **Process CPU Load:** `{d:.1}%`
            \\══════════════════════════════
            \\✨ **Bare-Metal Zig Engine v0.11**
        , .{ bot_count, h, m, s, global_state.nc_count.load(.monotonic), active_nc_count, metrics.ram_mb, metrics.cpu_percent });
        defer bot.allocator.free(status_msg);

        try bot.sendMessage(chat_id, status_msg, null);
        return;
    }

    // ────────────────────────── 3. ALL NC COMMANDS ──────────────────────────

    if (std.mem.eql(u8, cmd, "genosnc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e = GENOSNC_EMOJIS[random.uintLessThan(usize, GENOSNC_EMOJIS.len)];
            var pat = std.ArrayList(u8).init(bot.allocator);
            for (0..57) |_| {
                try pat.appendSlice("꧅");
                try pat.appendSlice(e);
            }
            try pat.appendSlice("꧅");
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} {s}", .{ args, pat.items });
            pat.deinit();
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🎀 **GENOS NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "timenc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = TIME_EMOJIS[random.uintLessThan(usize, TIME_EMOJIS.len)];
            const e2 = TIME_EMOJIS[random.uintLessThan(usize, TIME_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} {s} {s} ﹝ZIG-CORE﹞", .{ e1, args, e2 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "⏱️ **TIME NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "vishunc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const w = VISHUNC_WORD[random.uintLessThan(usize, VISHUNC_WORD.len)];
            const e = VISHU_EMOJIS[random.uintLessThan(usize, VISHU_EMOJIS.len)];
            var line = std.ArrayList(u8).init(bot.allocator);
            for (0..70) |_| try line.appendSlice(e);
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} {s}{s}", .{ args, w, line.items });
            line.deinit();
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🩸 **VISHU NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "villainnc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |idx| {
            const e = VILLAIN_EMOJIS[random.uintLessThan(usize, VILLAIN_EMOJIS.len)];
            const icons = [_][]const u8{ "🏴‍☠️", "🇦🇨", "☠️", "⚔️" };
            const c_icon = icons[random.uintLessThan(usize, icons.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} 𓆩 ♡{s}♡ 𓆪 𝐓ᴇʀɪ 𝐌ᴀᴀ 𝐑ɴᴅɪ ⸻❤️⸻🖤⸻💙 ~{s}{d}", .{ e, args, c_icon, idx + 1 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🏴‍☠️ **VILLAIN NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "vvgnc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |idx| {
            const h1 = HEART_EMOJIS[random.uintLessThan(usize, HEART_EMOJIS.len)];
            const h2 = HEART_EMOJIS[random.uintLessThan(usize, HEART_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} 𝐓ᴍᴋᴄ 𝐌ᴇ 𝐕ɪʟʟᴀɪɴ 𝐕ɪsʜᴜ 𝐆ᴇɴᴏs 𝐊ᴀ 𝐋ᴀɴᴅ 𒀱{s}𒀱{s} ~👑{d}", .{ args, h1, h2, idx + 1 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "⚡ **VVG NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "ncemo")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = NCEMO_EMOJIS[random.uintLessThan(usize, NCEMO_EMOJIS.len)];
            const e2 = NCEMO_EMOJIS[random.uintLessThan(usize, NCEMO_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} {s} {s}", .{ e1, args, e2 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🌸 **NCEMO STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "tmkcnc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e = GENOSNC_EMOJIS[random.uintLessThan(usize, GENOSNC_EMOJIS.len)];
            var pat = std.ArrayList(u8).init(bot.allocator);
            for (0..57) |_| {
                try pat.appendSlice("𒅒");
                try pat.appendSlice(e);
            }
            try pat.appendSlice("𒅒");
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} 𝐓𝐌𝐊𝐂 {s}", .{ args, pat.items });
            pat.deinit();
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🎀 **TMKC NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "mcnc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e = HEART_EMOJIS[random.uintLessThan(usize, HEART_EMOJIS.len)];
            var pat = std.ArrayList(u8).init(bot.allocator);
            for (0..57) |_| {
                try pat.appendSlice("⸻");
                try pat.appendSlice(e);
            }
            try pat.appendSlice("⸻");
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} 𝒎𝒂𝒅𝒂𝒓𝒄𝒉𝒐𝒅 𝒓𝒏𝒅𝒚𝒌𝒆 {s}", .{ args, pat.items });
            pat.deinit();
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🎀 **MC NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "😂nc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = FLAG_EMOJIS[random.uintLessThan(usize, FLAG_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "||{s}|| 𝐈𝐍𝐒𝐄 𝐌𝐈𝐋𝐈𝐘𝐄 {s} 𝐈𝐒𝐍𝐄 𝐂𝐇𝐔𝐃𝐍𝐄 𝐊𝐀 𝐂𝐎𝐔𝐑𝐒𝐄 𝐊𝐈𝐘𝐀 𝐇𝐀𝐈 ||{s}||", .{ e1, args, e1 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🌸 ** 😂 NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "😭nc")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = CRY_EMOJIS[random.uintLessThan(usize, CRY_EMOJIS.len)];
            const e2 = CRY_EMOJIS[random.uintLessThan(usize, CRY_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "😭{s}{s}{s}😭", .{ e1, args, e2 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🌸 ** 😭 NC STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "nc1")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = VISHU_EMOJIS[random.uintLessThan(usize, VISHU_EMOJIS.len)];
            const e2 = VISHU_EMOJIS[random.uintLessThan(usize, VISHU_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "{s} 𝘔𝘈𝘋𝘈𝘙𝘊𝘏𝘖𝘋 𝘖𝘠𝘌𝘌𝘌𝘌𝘌𝘌.....,{s}᳄᳄᳄᳄༺═──────────────═༻☟☜({s})", .{ args, e1, e2 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🌸 **NC1 STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "nc2")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = HEART_EMOJIS[random.uintLessThan(usize, HEART_EMOJIS.len)];
            const e2 = HEART_EMOJIS[random.uintLessThan(usize, HEART_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "<{s}>{s} तू हिजड़ा रेंडी के बच्चे छिनाल <{s}>", .{ e1, args, e2 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "🌸 **NC2 STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "nc3")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = NCEMO_EMOJIS[random.uintLessThan(usize, NCEMO_EMOJIS.len)];
            const e2 = RNDYKE_CHUD[random.uintLessThan(usize, RNDYKE_CHUD.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "{s}{s} {s}{s}", .{ e1, args, e2, e1 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "**NC3 STARTED**", null);
        return;
    }

    if (std.mem.eql(u8, cmd, "nc4")) {
        var titles = std.ArrayList([]const u8).init(bot.allocator);
        var prng = std.rand.DefaultPrng.init(@as(u64, @intCast(time.milliTimestamp())));
        const random = prng.random();

        for (0..30) |_| {
            const e1 = ALL_EMOJIS[random.uintLessThan(usize, ALL_EMOJIS.len)];
            const e2 = ALL_EMOJIS[random.uintLessThan(usize, ALL_EMOJIS.len)];
            const raw = try std.fmt.allocPrint(bot.allocator, "⟦ {s} ⟧ {s} ⟦ {s} ⟧", .{ e1, args, e2 });
            try titles.append(truncTitle(raw));
        }

        try startNcRelay(chat_id, titles.items);
        try bot.sendMessage(chat_id, "**NC4 STARTED**", null);
        return;
    }
