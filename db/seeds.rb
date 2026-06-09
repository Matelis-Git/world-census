# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
Vote.destroy_all
PollOption.destroy_all
Poll.destroy_all
User.destroy_all

def vote_on(user, poll, opt_idx)
  Vote.create!(
    user: user,
    poll: poll,
    poll_option: poll.poll_options.order(:id).to_a[opt_idx],
    country: user.country
  )
end

# --- Original users ---
usertest  = User.create!(email: "test@test.com",  username: "testuser_es", password: "123456", country: "ES")
usertest2 = User.create!(email: "user@test.com",  username: "worlduser",   password: "123456")

# --- 10 users from previous seed ---
alice    = User.create!(email: "alice@test.com",    username: "alice_berlin",  password: "123456", country: "DE")
bob      = User.create!(email: "bob@test.com",      username: "bob_saopaulo",  password: "123456", country: "BR")
carlos   = User.create!(email: "carlos@test.com",   username: "carlos_mx",     password: "123456", country: "MX")
diana    = User.create!(email: "diana@test.com",    username: "diana_tokyo",   password: "123456", country: "JP")
elena    = User.create!(email: "elena@test.com",    username: "elena_rome",    password: "123456", country: "IT")
frank    = User.create!(email: "frank@test.com",    username: "frank_nyc",     password: "123456", country: "US")
grace    = User.create!(email: "grace@test.com",    username: "grace_sydney",  password: "123456", country: "AU")
hans     = User.create!(email: "hans@test.com",     username: "hans_sthlm",    password: "123456", country: "SE")
isabella = User.create!(email: "isabella@test.com", username: "isabella_in",   password: "123456", country: "IN")
jack     = User.create!(email: "jack@test.com",     username: "jack_abuja",    password: "123456", country: "NG")

# --- 30 users from previous seed ---
sarah    = User.create!(email: "sarah@test.com",    username: "sarah_paris",   password: "123456", country: "FR")
thomas   = User.create!(email: "thomas@test.com",   username: "thomas_ldn",    password: "123456", country: "GB")
yuki     = User.create!(email: "yuki@test.com",     username: "yuki_kr",       password: "123456", country: "KR")
rafael   = User.create!(email: "rafael@test.com",   username: "rafael_ba",     password: "123456", country: "AR")
priya    = User.create!(email: "priya@test.com",    username: "priya_khi",     password: "123456", country: "PK")
liu      = User.create!(email: "liu@test.com",      username: "liu_beijing",   password: "123456", country: "CN")
amira    = User.create!(email: "amira@test.com",    username: "amira_eg",      password: "123456", country: "EG")
viktor   = User.create!(email: "viktor@test.com",   username: "viktor_msc",    password: "123456", country: "RU")
sofia    = User.create!(email: "sofia@test.com",    username: "sofia_waw",     password: "123456", country: "PL")
anders   = User.create!(email: "anders@test.com",   username: "anders_bgn",    password: "123456", country: "NO")
fatima   = User.create!(email: "fatima@test.com",   username: "fatima_casa",   password: "123456", country: "MA")
kofi     = User.create!(email: "kofi@test.com",     username: "kofi_accra",    password: "123456", country: "GH")
maria    = User.create!(email: "maria@test.com",    username: "maria_bog",     password: "123456", country: "CO")
dmitri   = User.create!(email: "dmitri@test.com",   username: "dmitri_kyiv",   password: "123456", country: "UA")
yaw      = User.create!(email: "yaw@test.com",      username: "yaw_nairobi",   password: "123456", country: "KE")
lena     = User.create!(email: "lena@test.com",     username: "lena_hki",      password: "123456", country: "FI")
ahmed    = User.create!(email: "ahmed@test.com",    username: "ahmed_riyadh",  password: "123456", country: "SA")
mei      = User.create!(email: "mei@test.com",      username: "mei_taipei",    password: "123456", country: "TW")
olga     = User.create!(email: "olga@test.com",     username: "olga_prague",   password: "123456", country: "CZ")
jose     = User.create!(email: "jose@test.com",     username: "jose_lima",     password: "123456", country: "PE")
nadia    = User.create!(email: "nadia@test.com",    username: "nadia_ist",     password: "123456", country: "TR")
kim      = User.create!(email: "kim@test.com",      username: "kim_jhb",       password: "123456", country: "ZA")
boris    = User.create!(email: "boris@test.com",    username: "boris_bud",     password: "123456", country: "HU")
aisha    = User.create!(email: "aisha@test.com",    username: "aisha_tunis",   password: "123456", country: "TN")
pedro    = User.create!(email: "pedro@test.com",    username: "pedro_lisbon",  password: "123456", country: "PT")
yara     = User.create!(email: "yara@test.com",     username: "yara_beirut",   password: "123456", country: "LB")
mikael   = User.create!(email: "mikael@test.com",   username: "mikael_cph",    password: "123456", country: "DK")
anya     = User.create!(email: "anya@test.com",     username: "anya_buc",      password: "123456", country: "RO")
chen     = User.create!(email: "chen@test.com",     username: "chen_sgp",      password: "123456", country: "SG")
zara     = User.create!(email: "zara@test.com",     username: "zara_mnl",      password: "123456", country: "PH")

# --- 100 new users ---
# Asia (25)
u1  = User.create!(email: "hiroshi@test.com",   username: "hiroshi_tok",   password: "123456", country: "JP")
u2  = User.create!(email: "kenji@test.com",     username: "kenji_osaka",   password: "123456", country: "JP")
u3  = User.create!(email: "arjun@test.com",     username: "arjun_delhi",   password: "123456", country: "IN")
u4  = User.create!(email: "deepak@test.com",    username: "deepak_mum",    password: "123456", country: "IN")
u5  = User.create!(email: "sunli@test.com",     username: "sunli_bj",      password: "123456", country: "CN")
u6  = User.create!(email: "mingzhu@test.com",   username: "mingzhu_sh",    password: "123456", country: "CN")
u7  = User.create!(email: "yuna@test.com",      username: "yuna_seoul",    password: "123456", country: "KR")
u8  = User.create!(email: "jinho@test.com",     username: "jinho_busan",   password: "123456", country: "KR")
u9  = User.create!(email: "nguyen@test.com",    username: "nguyen_hn",     password: "123456", country: "VN")
u10 = User.create!(email: "rangi@test.com",     username: "rangi_nz",      password: "123456", country: "NZ")
u11 = User.create!(email: "budi@test.com",      username: "budi_jkt",      password: "123456", country: "ID")
u12 = User.create!(email: "siti@test.com",      username: "siti_kl",       password: "123456", country: "MY")
u13 = User.create!(email: "burak@test.com",     username: "burak_ist",     password: "123456", country: "TR")
u14 = User.create!(email: "rin@test.com",       username: "rin_bkk",       password: "123456", country: "TH")
u15 = User.create!(email: "reza@test.com",      username: "reza_thr",      password: "123456", country: "IR")
u16 = User.create!(email: "layla@test.com",     username: "layla_uae",     password: "123456", country: "AE")
u17 = User.create!(email: "tariq@test.com",     username: "tariq_pak",     password: "123456", country: "PK")
u18 = User.create!(email: "sana@test.com",      username: "sana_bd",       password: "123456", country: "BD")
u19 = User.create!(email: "faisal@test.com",    username: "faisal_ksa",    password: "123456", country: "SA")
u20 = User.create!(email: "hana@test.com",      username: "hana_israel",   password: "123456", country: "IL")
u21 = User.create!(email: "omar@test.com",      username: "omar_cairo",    password: "123456", country: "EG")
u22 = User.create!(email: "yasmin@test.com",    username: "yasmin_jor",    password: "123456", country: "JO")
u23 = User.create!(email: "takeshi@test.com",   username: "takeshi_jp",    password: "123456", country: "JP")
u24 = User.create!(email: "preethi@test.com",   username: "preethi_in",    password: "123456", country: "IN")
u25 = User.create!(email: "ling@test.com",      username: "ling_sg",       password: "123456", country: "SG")

# Africa (15)
u26 = User.create!(email: "kwame@test.com",     username: "kwame_accra",   password: "123456", country: "GH")
u27 = User.create!(email: "tunde@test.com",     username: "tunde_lagos",   password: "123456", country: "NG")
u28 = User.create!(email: "nkechi@test.com",    username: "nkechi_ng",     password: "123456", country: "NG")
u29 = User.create!(email: "amara@test.com",     username: "amara_sl",      password: "123456", country: "SL")
u30 = User.create!(email: "makena@test.com",    username: "makena_ke",     password: "123456", country: "KE")
u31 = User.create!(email: "sipho@test.com",     username: "sipho_za",      password: "123456", country: "ZA")
u32 = User.create!(email: "adaeze@test.com",    username: "adaeze_ng",     password: "123456", country: "NG")
u33 = User.create!(email: "seun@test.com",      username: "seun_abuja",    password: "123456", country: "NG")
u34 = User.create!(email: "abena@test.com",     username: "abena_gh",      password: "123456", country: "GH")
u35 = User.create!(email: "ife@test.com",       username: "ife_ibadan",    password: "123456", country: "NG")
u36 = User.create!(email: "taraji@test.com",    username: "taraji_et",     password: "123456", country: "ET")
u37 = User.create!(email: "hamid@test.com",     username: "hamid_dz",      password: "123456", country: "DZ")
u38 = User.create!(email: "ismail@test.com",    username: "ismail_sn",     password: "123456", country: "SN")
u39 = User.create!(email: "nyambura@test.com",  username: "nyambura_ke",   password: "123456", country: "KE")
u40 = User.create!(email: "chidi@test.com",     username: "chidi_ng",      password: "123456", country: "NG")

# Europe (25)
u41 = User.create!(email: "chiara@test.com",    username: "chiara_rm",     password: "123456", country: "IT")
u42 = User.create!(email: "luca@test.com",      username: "luca_milan",    password: "123456", country: "IT")
u43 = User.create!(email: "baptiste@test.com",  username: "baptiste_fr",   password: "123456", country: "FR")
u44 = User.create!(email: "camille@test.com",   username: "camille_paris", password: "123456", country: "FR")
u45 = User.create!(email: "lennart@test.com",   username: "lennart_de",    password: "123456", country: "DE")
u46 = User.create!(email: "heike@test.com",     username: "heike_bln",     password: "123456", country: "DE")
u47 = User.create!(email: "tom@test.com",       username: "tom_ldn",       password: "123456", country: "GB")
u48 = User.create!(email: "poppy@test.com",     username: "poppy_gb",      password: "123456", country: "GB")
u49 = User.create!(email: "mateus@test.com",    username: "mateus_pl",     password: "123456", country: "PL")
u50 = User.create!(email: "agata@test.com",     username: "agata_waw",     password: "123456", country: "PL")
u51 = User.create!(email: "erik@test.com",      username: "erik_se",       password: "123456", country: "SE")
u52 = User.create!(email: "astrid@test.com",    username: "astrid_sthlm",  password: "123456", country: "SE")
u53 = User.create!(email: "eero@test.com",      username: "eero_fi",       password: "123456", country: "FI")
u54 = User.create!(email: "tuuli@test.com",     username: "tuuli_hki",     password: "123456", country: "FI")
u55 = User.create!(email: "elena_gr@test.com",  username: "elena_ath",     password: "123456", country: "GR")
u56 = User.create!(email: "nikos@test.com",     username: "nikos_gr",      password: "123456", country: "GR")
u57 = User.create!(email: "marek@test.com",     username: "marek_cz",      password: "123456", country: "CZ")
u58 = User.create!(email: "jana@test.com",      username: "jana_sk",       password: "123456", country: "SK")
u59 = User.create!(email: "tobias@test.com",    username: "tobias_at",     password: "123456", country: "AT")
u60 = User.create!(email: "silje@test.com",     username: "silje_no",      password: "123456", country: "NO")
u61 = User.create!(email: "sven@test.com",      username: "sven_dk",       password: "123456", country: "DK")
u62 = User.create!(email: "piia@test.com",      username: "piia_fi",       password: "123456", country: "FI")
u63 = User.create!(email: "fernanda@test.com",  username: "fernanda_es",   password: "123456", country: "ES")
u64 = User.create!(email: "pablo@test.com",     username: "pablo_mad",     password: "123456", country: "ES")
u65 = User.create!(email: "ioana@test.com",     username: "ioana_ro",      password: "123456", country: "RO")

# Americas (20)
u66 = User.create!(email: "marco@test.com",     username: "marco_br",      password: "123456", country: "BR")
u67 = User.create!(email: "ana@test.com",       username: "ana_rio",       password: "123456", country: "BR")
u68 = User.create!(email: "tyler@test.com",     username: "tyler_us",      password: "123456", country: "US")
u69 = User.create!(email: "ashley@test.com",    username: "ashley_nyc",    password: "123456", country: "US")
u70 = User.create!(email: "ethan@test.com",     username: "ethan_cal",     password: "123456", country: "US")
u71 = User.create!(email: "madison@test.com",   username: "madison_us",    password: "123456", country: "US")
u72 = User.create!(email: "liam@test.com",      username: "liam_ca",       password: "123456", country: "CA")
u73 = User.create!(email: "emma_ca@test.com",   username: "emma_toronto",  password: "123456", country: "CA")
u74 = User.create!(email: "camila@test.com",    username: "camila_mx",     password: "123456", country: "MX")
u75 = User.create!(email: "rodrigo@test.com",   username: "rodrigo_mx",    password: "123456", country: "MX")
u76 = User.create!(email: "valentina@test.com", username: "valentina_ar",  password: "123456", country: "AR")
u77 = User.create!(email: "mateo@test.com",     username: "mateo_bo",      password: "123456", country: "BO")
u78 = User.create!(email: "sofia_ve@test.com",  username: "sofia_cara",    password: "123456", country: "VE")
u79 = User.create!(email: "pablo_co@test.com",  username: "pablo_bog",     password: "123456", country: "CO")
u80 = User.create!(email: "isabela@test.com",   username: "isabela_sp",    password: "123456", country: "BR")
u81 = User.create!(email: "diego@test.com",     username: "diego_ba",      password: "123456", country: "AR")
u82 = User.create!(email: "lucia@test.com",     username: "lucia_uy",      password: "123456", country: "UY")
u83 = User.create!(email: "andres@test.com",    username: "andres_ec",     password: "123456", country: "EC")
u84 = User.create!(email: "carolina@test.com",  username: "carolina_cl",   password: "123456", country: "CL")
u85 = User.create!(email: "jorge@test.com",     username: "jorge_cu",      password: "123456", country: "CU")

# Oceania / Russia / Ukraine / Philippines / Other (15)
u86  = User.create!(email: "lachlan@test.com",  username: "lachlan_au",    password: "123456", country: "AU")
u87  = User.create!(email: "zoe@test.com",      username: "zoe_melb",      password: "123456", country: "AU")
u88  = User.create!(email: "finn@test.com",     username: "finn_ie",       password: "123456", country: "IE")
u89  = User.create!(email: "niamh@test.com",    username: "niamh_dub",     password: "123456", country: "IE")
u90  = User.create!(email: "maksim@test.com",   username: "maksim_ru",     password: "123456", country: "RU")
u91  = User.create!(email: "svetlana@test.com", username: "svetlana_ru",   password: "123456", country: "RU")
u92  = User.create!(email: "bohdan@test.com",   username: "bohdan_ua",     password: "123456", country: "UA")
u93  = User.create!(email: "mykola@test.com",   username: "mykola_kyi",    password: "123456", country: "UA")
u94  = User.create!(email: "bea@test.com",      username: "bea_ph",        password: "123456", country: "PH")
u95  = User.create!(email: "lito@test.com",     username: "lito_mnl",      password: "123456", country: "PH")
u96  = User.create!(email: "paola@test.com",    username: "paola_pe",      password: "123456", country: "PE")
u97  = User.create!(email: "renata@test.com",   username: "renata_br",     password: "123456", country: "BR")
u98  = User.create!(email: "aleksei@test.com",  username: "aleksei_ru",    password: "123456", country: "RU")
u99  = User.create!(email: "nour@test.com",     username: "nour_sy",       password: "123456", country: "SY")
u100 = User.create!(email: "taini@test.com",    username: "taini_br",      password: "123456", country: "BR")

# =============================================================================
# POLLS
# =============================================================================

# --- Original 5 polls ---
france_poll = Poll.create!(title_question: "Should France raise the minimum wage?", category: "economy", country: "france", user: usertest)
["Yes, significantly", "Yes, but gradually", "No, keep it as is", "No, it should be lowered"].each { |t| france_poll.poll_options.create!(text: t) }

nuclear_poll = Poll.create!(title_question: "Is nuclear energy the future of global power?", category: "politics", country: "global", user: usertest)
["Yes, it's our best option", "Only as a transition energy", "No, renewables are enough"].each { |t| nuclear_poll.poll_options.create!(text: t) }

psg_poll = Poll.create!(title_question: "Will PSG win the Champions League this year?", category: "social", country: "global", user: usertest)
["Definitely yes", "Maybe, it's possible", "Unlikely", "No chance"].each { |t| psg_poll.poll_options.create!(text: t) }

weekends_poll = Poll.create!(title_question: "Should weekends be 4 days long?", category: "social", country: "france", user: usertest)
["Yes, absolutely", "Yes, but only some workers", "No, 2 days is fine"].each { |t| weekends_poll.poll_options.create!(text: t) }

lights_poll = Poll.create!(title_question: "Should you leave the lights on in the dark?", category: "social", country: "global", user: usertest2)
["Yes, always", "Only in certain rooms", "No, save electricity"].each { |t| lights_poll.poll_options.create!(text: t) }

# --- Alice, Bob, Carlos polls ---
alice_poll = Poll.create!(title_question: "Should Germany increase defense spending?", category: "politics", country: "germany", user: alice)
["Yes, significantly", "Yes, moderately", "No, keep current levels", "No, reduce it"].each { |t| alice_poll.poll_options.create!(text: t) }

bob_poll = Poll.create!(title_question: "Should Brazil legalize cannabis?", category: "politics", country: "brazil", user: bob)
["Yes, fully legalize", "Only for medicinal use", "No, keep it illegal"].each { |t| bob_poll.poll_options.create!(text: t) }

carlos_poll = Poll.create!(title_question: "Is remote work better than office work?", category: "social", country: "global", user: carlos)
["Yes, remote is better", "Hybrid is best", "Office is better"].each { |t| carlos_poll.poll_options.create!(text: t) }

# --- 15 polls from previous seed ---
sarah_poll = Poll.create!(title_question: "Should France ban fast fashion?", category: "economy", country: "france", user: sarah)
["Yes, ban it completely", "Tax it heavily instead", "No, let consumers decide", "No, it supports local jobs"].each { |t| sarah_poll.poll_options.create!(text: t) }

thomas_poll = Poll.create!(title_question: "Should the UK rejoin the European Union?", category: "politics", country: "global", user: thomas)
["Yes, immediately", "Yes, after renegotiating terms", "No, Brexit was the right call"].each { |t| thomas_poll.poll_options.create!(text: t) }

yuki_poll = Poll.create!(title_question: "Is K-pop a major force in global culture?", category: "social", country: "global", user: yuki)
["Absolutely yes", "Yes, but it's just a trend", "Somewhat, but overhyped", "No, it's a niche interest"].each { |t| yuki_poll.poll_options.create!(text: t) }

rafael_poll = Poll.create!(title_question: "Should Argentina adopt the US dollar as its currency?", category: "economy", country: "argentina", user: rafael)
["Yes, to stop inflation", "Only partially dollarize", "No, keep the peso"].each { |t| rafael_poll.poll_options.create!(text: t) }

priya_poll = Poll.create!(title_question: "Should Pakistan invest more in renewable energy?", category: "politics", country: "global", user: priya)
["Yes, it's essential", "Yes, but gradually", "No, fossil fuels are more reliable"].each { |t| priya_poll.poll_options.create!(text: t) }

liu_poll = Poll.create!(title_question: "Should China reduce its carbon emissions faster?", category: "politics", country: "global", user: liu)
["Yes, it's urgent", "Yes, but at a fair global pace", "No, development comes first"].each { |t| liu_poll.poll_options.create!(text: t) }

amira_poll = Poll.create!(title_question: "Is mass tourism good for Egypt's cultural heritage?", category: "social", country: "global", user: amira)
["Yes, it funds preservation", "Neutral, with proper management", "No, it causes damage"].each { |t| amira_poll.poll_options.create!(text: t) }

viktor_poll = Poll.create!(title_question: "Should Russia be allowed back in international sports?", category: "social", country: "global", user: viktor)
["Yes, athletes shouldn't be punished", "Yes, under strict conditions", "No, not until the conflict ends"].each { |t| viktor_poll.poll_options.create!(text: t) }

sofia_poll = Poll.create!(title_question: "Should Poland adopt the Euro?", category: "economy", country: "global", user: sofia)
["Yes, for economic stability", "Yes, but not yet", "No, the zloty works fine"].each { |t| sofia_poll.poll_options.create!(text: t) }

anders_poll = Poll.create!(title_question: "Should Norway stop oil production for climate reasons?", category: "politics", country: "global", user: anders)
["Yes, immediately", "Yes, phase it out by 2030", "No, use oil revenue for green tech", "No, it's core to Norway's economy"].each { |t| anders_poll.poll_options.create!(text: t) }

fatima_poll = Poll.create!(title_question: "Should Morocco export solar energy to Europe?", category: "economy", country: "global", user: fatima)
["Yes, it's a great opportunity", "Yes, but keep enough domestically", "No, focus on local needs first"].each { |t| fatima_poll.poll_options.create!(text: t) }

kofi_poll = Poll.create!(title_question: "Should African nations create a single currency?", category: "economy", country: "global", user: kofi)
["Yes, like the Euro", "Yes, but only regionally", "No, each country is too different"].each { |t| kofi_poll.poll_options.create!(text: t) }

maria_poll = Poll.create!(title_question: "Should Colombia fully legalize recreational drugs?", category: "politics", country: "colombia", user: maria)
["Yes, full legalization", "Yes, decriminalize only", "No, keep current laws", "No, enforce stricter laws"].each { |t| maria_poll.poll_options.create!(text: t) }

dmitri_poll = Poll.create!(title_question: "Should Ukraine join NATO?", category: "politics", country: "global", user: dmitri)
["Yes, immediately", "Yes, after the conflict ends", "No, it's too geopolitically risky", "No, Ukraine should stay neutral"].each { |t| dmitri_poll.poll_options.create!(text: t) }

yaw_poll = Poll.create!(title_question: "Should African governments prioritize tech hubs over agriculture?", category: "economy", country: "global", user: yaw)
["Yes, tech is the future", "Balance both equally", "No, food security comes first"].each { |t| yaw_poll.poll_options.create!(text: t) }

# --- 10 new polls ---
student_debt_poll = Poll.create!(title_question: "Should the US cancel all student loan debt?", category: "economy", country: "global", user: u68)
["Yes, cancel it all immediately", "Yes, cancel partially for low earners", "No, borrowers should repay", "No, it's unfair to those who already paid"].each { |t| student_debt_poll.poll_options.create!(text: t) }

social_media_ban_poll = Poll.create!(title_question: "Should social media be banned for under-16s?", category: "social", country: "global", user: u47)
["Yes, ban it completely", "Yes, but only certain platforms", "No, education is a better solution", "No, that's too restrictive"].each { |t| social_media_ban_poll.poll_options.create!(text: t) }

germany_nuclear_poll = Poll.create!(title_question: "Was Germany right to close all its nuclear plants?", category: "politics", country: "germany", user: u45)
["Yes, it was the right call", "No, we need nuclear for the energy transition", "No, it was a huge strategic mistake"].each { |t| germany_nuclear_poll.poll_options.create!(text: t) }

japan_immigration_poll = Poll.create!(title_question: "Should Japan open its borders to more immigration?", category: "social", country: "japan", user: u1)
["Yes, Japan needs it urgently", "Yes, but selectively and gradually", "No, Japan should preserve its culture", "No, automation can fill the gaps"].each { |t| japan_immigration_poll.poll_options.create!(text: t) }

india_ubi_poll = Poll.create!(title_question: "Should India adopt a universal basic income?", category: "economy", country: "india", user: u3)
["Yes, it would transform the economy", "Yes, but only for the poorest citizens", "No, it would cause inflation", "No, focus on job creation instead"].each { |t| india_ubi_poll.poll_options.create!(text: t) }

reparations_poll = Poll.create!(title_question: "Should Western nations pay reparations for colonialism?", category: "politics", country: "global", user: u26)
["Yes, formal reparations are long overdue", "Yes, but through development aid instead", "No, current generations aren't responsible", "No, it would create more division"].each { |t| reparations_poll.poll_options.create!(text: t) }

eu_refugees_poll = Poll.create!(title_question: "Should the EU share refugee intake equally among member states?", category: "politics", country: "global", user: u41)
["Yes, the EU must share the burden", "Yes, but with stricter asylum rules", "No, border countries should manage it", "No, limit all immigration first"].each { |t| eu_refugees_poll.poll_options.create!(text: t) }

amazon_poll = Poll.create!(title_question: "Should the Amazon rainforest have international legal protection?", category: "politics", country: "global", user: u66)
["Yes, it belongs to all of humanity", "Yes, but with fair compensation for Brazil", "No, it's Brazil's sovereign territory"].each { |t| amazon_poll.poll_options.create!(text: t) }

football_poll = Poll.create!(title_question: "Is football (soccer) the world's greatest sport?", category: "social", country: "global", user: u27)
["Yes, undeniably", "Yes, but it depends on the region", "No, other sports are just as great", "No, the sport has too many problems"].each { |t| football_poll.poll_options.create!(text: t) }

ai_copyright_poll = Poll.create!(title_question: "Should AI-generated art be protected by copyright?", category: "social", country: "global", user: u7)
["Yes, whoever prompted the AI should own it", "Only if a human significantly directed the output", "No, AI art belongs to the public domain", "No, only human-made art deserves protection"].each { |t| ai_copyright_poll.poll_options.create!(text: t) }

# =============================================================================
# VOTES — original users
# =============================================================================

vote_on(alice,    nuclear_poll,  0)
vote_on(alice,    france_poll,   1)
vote_on(alice,    bob_poll,      0)

vote_on(bob,      france_poll,   0)
vote_on(bob,      carlos_poll,   1)

vote_on(carlos,   lights_poll,   2)
vote_on(carlos,   alice_poll,    1)

vote_on(diana,    nuclear_poll,  1)
vote_on(diana,    psg_poll,      1)
vote_on(diana,    weekends_poll, 0)

vote_on(elena,    france_poll,   1)
vote_on(elena,    nuclear_poll,  2)
vote_on(elena,    alice_poll,    0)

vote_on(frank,    nuclear_poll,  0)
vote_on(frank,    psg_poll,      2)
vote_on(frank,    carlos_poll,   0)

vote_on(grace,    weekends_poll, 0)
vote_on(grace,    lights_poll,   1)
vote_on(grace,    bob_poll,      1)

vote_on(hans,     france_poll,   0)
vote_on(hans,     weekends_poll, 0)
vote_on(hans,     nuclear_poll,  1)

vote_on(isabella, nuclear_poll,  2)
vote_on(isabella, lights_poll,   2)
vote_on(isabella, carlos_poll,   1)

vote_on(jack,     psg_poll,      3)
vote_on(jack,     lights_poll,   0)
vote_on(jack,     alice_poll,    3)

# --- 15 poll-creator users ---
vote_on(sarah,    nuclear_poll,  0)
vote_on(sarah,    weekends_poll, 0)
vote_on(sarah,    carlos_poll,   1)
vote_on(sarah,    bob_poll,      0)

vote_on(thomas,   nuclear_poll,  0)
vote_on(thomas,   psg_poll,      1)
vote_on(thomas,   alice_poll,    2)

vote_on(yuki,     psg_poll,      1)
vote_on(yuki,     lights_poll,   2)
vote_on(yuki,     carlos_poll,   1)

vote_on(rafael,   france_poll,   1)
vote_on(rafael,   nuclear_poll,  1)
vote_on(rafael,   lights_poll,   1)

vote_on(priya,    nuclear_poll,  0)
vote_on(priya,    weekends_poll, 0)
vote_on(priya,    alice_poll,    0)

vote_on(liu,      nuclear_poll,  1)
vote_on(liu,      lights_poll,   2)
vote_on(liu,      carlos_poll,   0)

vote_on(amira,    psg_poll,      1)
vote_on(amira,    weekends_poll, 1)
vote_on(amira,    bob_poll,      1)

vote_on(viktor,   nuclear_poll,  0)
vote_on(viktor,   psg_poll,      3)
vote_on(viktor,   alice_poll,    0)

vote_on(sofia,    france_poll,   0)
vote_on(sofia,    weekends_poll, 0)
vote_on(sofia,    alice_poll,    1)

vote_on(anders,   nuclear_poll,  2)
vote_on(anders,   lights_poll,   2)
vote_on(anders,   carlos_poll,   1)

vote_on(fatima,   psg_poll,      1)
vote_on(fatima,   weekends_poll, 0)
vote_on(fatima,   bob_poll,      1)

vote_on(kofi,     nuclear_poll,  1)
vote_on(kofi,     lights_poll,   1)
vote_on(kofi,     carlos_poll,   2)

vote_on(maria,    france_poll,   0)
vote_on(maria,    bob_poll,      0)
vote_on(maria,    carlos_poll,   1)

vote_on(dmitri,   nuclear_poll,  0)
vote_on(dmitri,   alice_poll,    0)
vote_on(dmitri,   carlos_poll,   0)

vote_on(yaw,      lights_poll,   2)
vote_on(yaw,      bob_poll,      1)
vote_on(yaw,      carlos_poll,   2)

# --- 15 voter-only users ---
vote_on(lena,     nuclear_poll,  2)
vote_on(lena,     weekends_poll, 0)
vote_on(lena,     anders_poll,   0)

vote_on(ahmed,    nuclear_poll,  0)
vote_on(ahmed,    psg_poll,      2)
vote_on(ahmed,    amira_poll,    0)

vote_on(mei,      psg_poll,      1)
vote_on(mei,      yuki_poll,     0)
vote_on(mei,      liu_poll,      1)

vote_on(olga,     france_poll,   1)
vote_on(olga,     weekends_poll, 0)
vote_on(olga,     sofia_poll,    0)

vote_on(jose,     bob_poll,      0)
vote_on(jose,     carlos_poll,   1)
vote_on(jose,     rafael_poll,   0)

vote_on(nadia,    nuclear_poll,  1)
vote_on(nadia,    weekends_poll, 0)
vote_on(nadia,    amira_poll,    1)

vote_on(kim,      lights_poll,   2)
vote_on(kim,      kofi_poll,     0)
vote_on(kim,      yaw_poll,      1)

vote_on(boris,    france_poll,   0)
vote_on(boris,    weekends_poll, 0)
vote_on(boris,    sofia_poll,    0)

vote_on(aisha,    weekends_poll, 0)
vote_on(aisha,    fatima_poll,   0)
vote_on(aisha,    maria_poll,    1)

vote_on(pedro,    france_poll,   0)
vote_on(pedro,    weekends_poll, 0)
vote_on(pedro,    thomas_poll,   0)

vote_on(yara,     nuclear_poll,  1)
vote_on(yara,     amira_poll,    1)
vote_on(yara,     dmitri_poll,   0)

vote_on(mikael,   nuclear_poll,  0)
vote_on(mikael,   weekends_poll, 0)
vote_on(mikael,   anders_poll,   0)

vote_on(anya,     france_poll,   1)
vote_on(anya,     weekends_poll, 0)
vote_on(anya,     sofia_poll,    0)

vote_on(chen,     psg_poll,      1)
vote_on(chen,     carlos_poll,   1)
vote_on(chen,     yuki_poll,     0)

vote_on(zara,     bob_poll,      1)
vote_on(zara,     carlos_poll,   0)
vote_on(zara,     priya_poll,    0)

# =============================================================================
# VOTES — 100 new users
# =============================================================================

# Asia
vote_on(u1,  japan_immigration_poll, 2); vote_on(u1,  nuclear_poll,         1); vote_on(u1,  ai_copyright_poll,    1)
vote_on(u2,  japan_immigration_poll, 1); vote_on(u2,  yuki_poll,            0); vote_on(u2,  psg_poll,             1)
vote_on(u3,  india_ubi_poll,         0); vote_on(u3,  priya_poll,           0); vote_on(u3,  nuclear_poll,         1)
vote_on(u4,  india_ubi_poll,         2); vote_on(u4,  carlos_poll,          1); vote_on(u4,  lights_poll,          1)
vote_on(u5,  liu_poll,               0); vote_on(u5,  nuclear_poll,         0); vote_on(u5,  ai_copyright_poll,    2)
vote_on(u6,  liu_poll,               1); vote_on(u6,  yuki_poll,            1); vote_on(u6,  carlos_poll,          1)
vote_on(u7,  yuki_poll,              0); vote_on(u7,  ai_copyright_poll,    0); vote_on(u7,  carlos_poll,          1)
vote_on(u8,  yuki_poll,              1); vote_on(u8,  japan_immigration_poll,3); vote_on(u8,  football_poll,        0)
vote_on(u9,  football_poll,          0); vote_on(u9,  nuclear_poll,         1); vote_on(u9,  carlos_poll,          1)
vote_on(u10, anders_poll,            1); vote_on(u10, lights_poll,          1); vote_on(u10, football_poll,        1)
vote_on(u11, football_poll,          0); vote_on(u11, nuclear_poll,         1); vote_on(u11, yaw_poll,             1)
vote_on(u12, football_poll,          0); vote_on(u12, priya_poll,           0); vote_on(u12, yuki_poll,            2)
vote_on(u13, eu_refugees_poll,       0); vote_on(u13, france_poll,          1); vote_on(u13, nuclear_poll,         0)
vote_on(u14, football_poll,          0); vote_on(u14, yuki_poll,            2); vote_on(u14, carlos_poll,          1)
vote_on(u15, nuclear_poll,           0); vote_on(u15, lights_poll,          2); vote_on(u15, reparations_poll,     2)
vote_on(u16, nuclear_poll,           0); vote_on(u16, fatima_poll,          1); vote_on(u16, football_poll,        1)
vote_on(u17, priya_poll,             0); vote_on(u17, nuclear_poll,         0); vote_on(u17, india_ubi_poll,       1)
vote_on(u18, india_ubi_poll,         0); vote_on(u18, yaw_poll,             1); vote_on(u18, lights_poll,          2)
vote_on(u19, nuclear_poll,           0); vote_on(u19, anders_poll,          3); vote_on(u19, fatima_poll,          0)
vote_on(u20, nuclear_poll,           0); vote_on(u20, reparations_poll,     2); vote_on(u20, weekends_poll,        0)
vote_on(u21, amira_poll,             0); vote_on(u21, fatima_poll,          0); vote_on(u21, football_poll,        0)
vote_on(u22, amira_poll,             1); vote_on(u22, eu_refugees_poll,     0); vote_on(u22, nuclear_poll,         1)
vote_on(u23, japan_immigration_poll, 2); vote_on(u23, ai_copyright_poll,    1); vote_on(u23, nuclear_poll,         1)
vote_on(u24, india_ubi_poll,         1); vote_on(u24, priya_poll,           1); vote_on(u24, weekends_poll,        0)
vote_on(u25, nuclear_poll,           0); vote_on(u25, yuki_poll,            0); vote_on(u25, ai_copyright_poll,    0)

# Africa
vote_on(u26, kofi_poll,              0); vote_on(u26, reparations_poll,     0); vote_on(u26, yaw_poll,             0)
vote_on(u27, football_poll,          0); vote_on(u27, reparations_poll,     0); vote_on(u27, kofi_poll,            1)
vote_on(u28, reparations_poll,       0); vote_on(u28, kofi_poll,            0); vote_on(u28, yaw_poll,             0)
vote_on(u29, reparations_poll,       0); vote_on(u29, yaw_poll,             1); vote_on(u29, football_poll,        1)
vote_on(u30, yaw_poll,               1); vote_on(u30, kofi_poll,            1); vote_on(u30, reparations_poll,     1)
vote_on(u31, reparations_poll,       0); vote_on(u31, football_poll,        0); vote_on(u31, kofi_poll,            1)
vote_on(u32, football_poll,          0); vote_on(u32, yaw_poll,             0); vote_on(u32, amira_poll,           0)
vote_on(u33, reparations_poll,       0); vote_on(u33, football_poll,        0); vote_on(u33, kofi_poll,            0)
vote_on(u34, kofi_poll,              0); vote_on(u34, fatima_poll,          0); vote_on(u34, reparations_poll,     1)
vote_on(u35, football_poll,          0); vote_on(u35, kofi_poll,            0); vote_on(u35, yaw_poll,             2)
vote_on(u36, yaw_poll,               1); vote_on(u36, reparations_poll,     1); vote_on(u36, lights_poll,          2)
vote_on(u37, fatima_poll,            1); vote_on(u37, reparations_poll,     0); vote_on(u37, amira_poll,           0)
vote_on(u38, fatima_poll,            0); vote_on(u38, reparations_poll,     0); vote_on(u38, kofi_poll,            1)
vote_on(u39, yaw_poll,               0); vote_on(u39, reparations_poll,     0); vote_on(u39, kofi_poll,            0)
vote_on(u40, football_poll,          0); vote_on(u40, kofi_poll,            0); vote_on(u40, reparations_poll,     1)

# Europe
vote_on(u41, eu_refugees_poll,       0); vote_on(u41, weekends_poll,        0); vote_on(u41, carlos_poll,          1)
vote_on(u42, eu_refugees_poll,       1); vote_on(u42, football_poll,        0); vote_on(u42, nuclear_poll,         1)
vote_on(u43, france_poll,            1); vote_on(u43, weekends_poll,        0); vote_on(u43, eu_refugees_poll,     1)
vote_on(u44, france_poll,            0); vote_on(u44, weekends_poll,        0); vote_on(u44, social_media_ban_poll, 0)
vote_on(u45, germany_nuclear_poll,   1); vote_on(u45, alice_poll,           1); vote_on(u45, social_media_ban_poll, 0)
vote_on(u46, germany_nuclear_poll,   0); vote_on(u46, weekends_poll,        0); vote_on(u46, carlos_poll,          1)
vote_on(u47, thomas_poll,            0); vote_on(u47, social_media_ban_poll, 0); vote_on(u47, student_debt_poll,   0)
vote_on(u48, thomas_poll,            1); vote_on(u48, social_media_ban_poll, 1); vote_on(u48, weekends_poll,       0)
vote_on(u49, sofia_poll,             0); vote_on(u49, eu_refugees_poll,     2); vote_on(u49, germany_nuclear_poll, 2)
vote_on(u50, sofia_poll,             0); vote_on(u50, weekends_poll,        0); vote_on(u50, alice_poll,           1)
vote_on(u51, anders_poll,            2); vote_on(u51, nuclear_poll,         0); vote_on(u51, weekends_poll,        0)
vote_on(u52, anders_poll,            1); vote_on(u52, social_media_ban_poll, 0); vote_on(u52, weekends_poll,       0)
vote_on(u53, anders_poll,            1); vote_on(u53, nuclear_poll,         2); vote_on(u53, eu_refugees_poll,     2)
vote_on(u54, anders_poll,            0); vote_on(u54, weekends_poll,        0); vote_on(u54, social_media_ban_poll, 1)
vote_on(u55, eu_refugees_poll,       0); vote_on(u55, reparations_poll,     2); vote_on(u55, nuclear_poll,         1)
vote_on(u56, eu_refugees_poll,       0); vote_on(u56, football_poll,        0); vote_on(u56, weekends_poll,        0)
vote_on(u57, sofia_poll,             1); vote_on(u57, eu_refugees_poll,     3); vote_on(u57, germany_nuclear_poll, 1)
vote_on(u58, eu_refugees_poll,       2); vote_on(u58, weekends_poll,        0); vote_on(u58, nuclear_poll,         1)
vote_on(u59, eu_refugees_poll,       0); vote_on(u59, alice_poll,           1); vote_on(u59, weekends_poll,        1)
vote_on(u60, anders_poll,            0); vote_on(u60, nuclear_poll,         2); vote_on(u60, eu_refugees_poll,     1)
vote_on(u61, anders_poll,            1); vote_on(u61, social_media_ban_poll, 2); vote_on(u61, weekends_poll,       0)
vote_on(u62, anders_poll,            0); vote_on(u62, lights_poll,          2); vote_on(u62, nuclear_poll,         0)
vote_on(u63, eu_refugees_poll,       1); vote_on(u63, france_poll,          1); vote_on(u63, weekends_poll,        0)
vote_on(u64, football_poll,          0); vote_on(u64, eu_refugees_poll,     2); vote_on(u64, weekends_poll,        1)
vote_on(u65, eu_refugees_poll,       0); vote_on(u65, sofia_poll,           0); vote_on(u65, nuclear_poll,         1)

# Americas
vote_on(u66, amazon_poll,            0); vote_on(u66, bob_poll,             0); vote_on(u66, football_poll,        0)
vote_on(u67, amazon_poll,            1); vote_on(u67, bob_poll,             1); vote_on(u67, football_poll,        0)
vote_on(u68, student_debt_poll,      0); vote_on(u68, nuclear_poll,         0); vote_on(u68, social_media_ban_poll, 0)
vote_on(u69, student_debt_poll,      0); vote_on(u69, social_media_ban_poll, 0); vote_on(u69, carlos_poll,         0)
vote_on(u70, student_debt_poll,      1); vote_on(u70, nuclear_poll,         0); vote_on(u70, ai_copyright_poll,    0)
vote_on(u71, student_debt_poll,      0); vote_on(u71, social_media_ban_poll, 0); vote_on(u71, weekends_poll,       0)
vote_on(u72, student_debt_poll,      1); vote_on(u72, thomas_poll,          1); vote_on(u72, carlos_poll,          1)
vote_on(u73, social_media_ban_poll,  1); vote_on(u73, student_debt_poll,    2); vote_on(u73, carlos_poll,          0)
vote_on(u74, carlos_poll,            1); vote_on(u74, bob_poll,             0); vote_on(u74, student_debt_poll,    2)
vote_on(u75, carlos_poll,            0); vote_on(u75, bob_poll,             1); vote_on(u75, football_poll,        0)
vote_on(u76, rafael_poll,            1); vote_on(u76, student_debt_poll,    2); vote_on(u76, carlos_poll,          1)
vote_on(u77, rafael_poll,            2); vote_on(u77, yaw_poll,             1); vote_on(u77, football_poll,        1)
vote_on(u78, rafael_poll,            0); vote_on(u78, reparations_poll,     1); vote_on(u78, lights_poll,          1)
vote_on(u79, maria_poll,             1); vote_on(u79, amazon_poll,          1); vote_on(u79, bob_poll,             0)
vote_on(u80, amazon_poll,            0); vote_on(u80, football_poll,        0); vote_on(u80, bob_poll,             0)
vote_on(u81, rafael_poll,            0); vote_on(u81, football_poll,        0); vote_on(u81, student_debt_poll,    3)
vote_on(u82, football_poll,          0); vote_on(u82, carlos_poll,          1); vote_on(u82, amazon_poll,          2)
vote_on(u83, amazon_poll,            0); vote_on(u83, reparations_poll,     1); vote_on(u83, bob_poll,             0)
vote_on(u84, amazon_poll,            1); vote_on(u84, student_debt_poll,    2); vote_on(u84, carlos_poll,          0)
vote_on(u85, reparations_poll,       0); vote_on(u85, bob_poll,             0); vote_on(u85, student_debt_poll,    3)

# Oceania / Russia / Ukraine / Philippines / Other
vote_on(u86,  anders_poll,           2); vote_on(u86,  nuclear_poll,        0); vote_on(u86,  football_poll,       1)
vote_on(u87,  nuclear_poll,          2); vote_on(u87,  social_media_ban_poll,0); vote_on(u87,  carlos_poll,        1)
vote_on(u88,  thomas_poll,           0); vote_on(u88,  eu_refugees_poll,    0); vote_on(u88,  social_media_ban_poll,1)
vote_on(u89,  thomas_poll,           1); vote_on(u89,  social_media_ban_poll,0); vote_on(u89,  weekends_poll,      0)
vote_on(u90,  viktor_poll,           0); vote_on(u90,  nuclear_poll,        0); vote_on(u90,  dmitri_poll,         2)
vote_on(u91,  viktor_poll,           1); vote_on(u91,  nuclear_poll,        1); vote_on(u91,  carlos_poll,         0)
vote_on(u92,  dmitri_poll,           0); vote_on(u92,  viktor_poll,         2); vote_on(u92,  eu_refugees_poll,    0)
vote_on(u93,  dmitri_poll,           1); vote_on(u93,  viktor_poll,         2); vote_on(u93,  nuclear_poll,        0)
vote_on(u94,  football_poll,         0); vote_on(u94,  yuki_poll,           0); vote_on(u94,  social_media_ban_poll,0)
vote_on(u95,  football_poll,         1); vote_on(u95,  carlos_poll,         1); vote_on(u95,  yuki_poll,           1)
vote_on(u96,  rafael_poll,           0); vote_on(u96,  reparations_poll,    1); vote_on(u96,  student_debt_poll,   2)
vote_on(u97,  amazon_poll,           0); vote_on(u97,  football_poll,       0); vote_on(u97,  bob_poll,            1)
vote_on(u98,  viktor_poll,           0); vote_on(u98,  nuclear_poll,        0); vote_on(u98,  dmitri_poll,         2)
vote_on(u99,  eu_refugees_poll,      0); vote_on(u99,  reparations_poll,    0); vote_on(u99,  dmitri_poll,         0)
vote_on(u100, amazon_poll,           1); vote_on(u100, football_poll,       0); vote_on(u100, bob_poll,            0)

p "Seeded #{Poll.count} polls, #{PollOption.count} options, #{User.count} users, and #{Vote.count} votes"
