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
usertest  = User.create!(email: "test@test.com", password: "123456", country: "ES")
usertest2 = User.create!(email: "user@test.com", password: "123456")

# --- 10 users from previous seed ---
alice    = User.create!(email: "alice@test.com",    password: "123456", country: "DE")
bob      = User.create!(email: "bob@test.com",      password: "123456", country: "BR")
carlos   = User.create!(email: "carlos@test.com",   password: "123456", country: "MX")
diana    = User.create!(email: "diana@test.com",    password: "123456", country: "JP")
elena    = User.create!(email: "elena@test.com",    password: "123456", country: "IT")
frank    = User.create!(email: "frank@test.com",    password: "123456", country: "US")
grace    = User.create!(email: "grace@test.com",    password: "123456", country: "AU")
hans     = User.create!(email: "hans@test.com",     password: "123456", country: "SE")
isabella = User.create!(email: "isabella@test.com", password: "123456", country: "IN")
jack     = User.create!(email: "jack@test.com",     password: "123456", country: "NG")

# --- 30 new users: first 15 create polls, last 15 vote only ---
sarah    = User.create!(email: "sarah@test.com",    password: "123456", country: "FR")
thomas   = User.create!(email: "thomas@test.com",   password: "123456", country: "GB")
yuki     = User.create!(email: "yuki@test.com",     password: "123456", country: "KR")
rafael   = User.create!(email: "rafael@test.com",   password: "123456", country: "AR")
priya    = User.create!(email: "priya@test.com",    password: "123456", country: "PK")
liu      = User.create!(email: "liu@test.com",      password: "123456", country: "CN")
amira    = User.create!(email: "amira@test.com",    password: "123456", country: "EG")
viktor   = User.create!(email: "viktor@test.com",   password: "123456", country: "RU")
sofia    = User.create!(email: "sofia@test.com",    password: "123456", country: "PL")
anders   = User.create!(email: "anders@test.com",   password: "123456", country: "NO")
fatima   = User.create!(email: "fatima@test.com",   password: "123456", country: "MA")
kofi     = User.create!(email: "kofi@test.com",     password: "123456", country: "GH")
maria    = User.create!(email: "maria@test.com",    password: "123456", country: "CO")
dmitri   = User.create!(email: "dmitri@test.com",   password: "123456", country: "UA")
yaw      = User.create!(email: "yaw@test.com",      password: "123456", country: "KE")
lena     = User.create!(email: "lena@test.com",     password: "123456", country: "FI")
ahmed    = User.create!(email: "ahmed@test.com",    password: "123456", country: "SA")
mei      = User.create!(email: "mei@test.com",      password: "123456", country: "TW")
olga     = User.create!(email: "olga@test.com",     password: "123456", country: "CZ")
jose     = User.create!(email: "jose@test.com",     password: "123456", country: "PE")
nadia    = User.create!(email: "nadia@test.com",    password: "123456", country: "TR")
kim      = User.create!(email: "kim@test.com",      password: "123456", country: "ZA")
boris    = User.create!(email: "boris@test.com",    password: "123456", country: "HU")
aisha    = User.create!(email: "aisha@test.com",    password: "123456", country: "TN")
pedro    = User.create!(email: "pedro@test.com",    password: "123456", country: "PT")
yara     = User.create!(email: "yara@test.com",     password: "123456", country: "LB")
mikael   = User.create!(email: "mikael@test.com",   password: "123456", country: "DK")
anya     = User.create!(email: "anya@test.com",     password: "123456", country: "RO")
chen     = User.create!(email: "chen@test.com",     password: "123456", country: "SG")
zara     = User.create!(email: "zara@test.com",     password: "123456", country: "PH")

# =============================================================================
# POLLS
# =============================================================================

# --- Original 5 polls (usertest / usertest2) ---
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

# --- 15 new polls from new users ---
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

# =============================================================================
# VOTES
# =============================================================================

# --- Original 10 users ---
vote_on(alice,    nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(alice,    france_poll,   1)  # "Yes, but gradually"
vote_on(alice,    bob_poll,      0)  # "Yes, fully legalize"

vote_on(bob,      france_poll,   0)  # "Yes, significantly"
vote_on(bob,      carlos_poll,   1)  # "Hybrid is best"

vote_on(carlos,   lights_poll,   2)  # "No, save electricity"
vote_on(carlos,   alice_poll,    1)  # "Yes, moderately"

vote_on(diana,    nuclear_poll,  1)  # "Only as a transition energy"
vote_on(diana,    psg_poll,      1)  # "Maybe, it's possible"
vote_on(diana,    weekends_poll, 0)  # "Yes, absolutely"

vote_on(elena,    france_poll,   1)  # "Yes, but gradually"
vote_on(elena,    nuclear_poll,  2)  # "No, renewables are enough"
vote_on(elena,    alice_poll,    0)  # "Yes, significantly"

vote_on(frank,    nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(frank,    psg_poll,      2)  # "Unlikely"
vote_on(frank,    carlos_poll,   0)  # "Yes, remote is better"

vote_on(grace,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(grace,    lights_poll,   1)  # "Only in certain rooms"
vote_on(grace,    bob_poll,      1)  # "Only for medicinal use"

vote_on(hans,     france_poll,   0)  # "Yes, significantly"
vote_on(hans,     weekends_poll, 0)  # "Yes, absolutely"
vote_on(hans,     nuclear_poll,  1)  # "Only as a transition energy"

vote_on(isabella, nuclear_poll,  2)  # "No, renewables are enough"
vote_on(isabella, lights_poll,   2)  # "No, save electricity"
vote_on(isabella, carlos_poll,   1)  # "Hybrid is best"

vote_on(jack,     psg_poll,      3)  # "No chance"
vote_on(jack,     lights_poll,   0)  # "Yes, always"
vote_on(jack,     alice_poll,    3)  # "No, reduce it"

# --- 15 new poll creators also vote ---
vote_on(sarah,    nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(sarah,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(sarah,    carlos_poll,   1)  # "Hybrid is best"
vote_on(sarah,    bob_poll,      0)  # "Yes, fully legalize"

vote_on(thomas,   nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(thomas,   psg_poll,      1)  # "Maybe, it's possible"
vote_on(thomas,   alice_poll,    2)  # "No, keep current levels"

vote_on(yuki,     psg_poll,      1)  # "Maybe, it's possible"
vote_on(yuki,     lights_poll,   2)  # "No, save electricity"
vote_on(yuki,     carlos_poll,   1)  # "Hybrid is best"

vote_on(rafael,   france_poll,   1)  # "Yes, but gradually"
vote_on(rafael,   nuclear_poll,  1)  # "Only as a transition energy"
vote_on(rafael,   lights_poll,   1)  # "Only in certain rooms"

vote_on(priya,    nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(priya,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(priya,    alice_poll,    0)  # "Yes, significantly"

vote_on(liu,      nuclear_poll,  1)  # "Only as a transition energy"
vote_on(liu,      lights_poll,   2)  # "No, save electricity"
vote_on(liu,      carlos_poll,   0)  # "Yes, remote is better"

vote_on(amira,    psg_poll,      1)  # "Maybe, it's possible"
vote_on(amira,    weekends_poll, 1)  # "Yes, but only some workers"
vote_on(amira,    bob_poll,      1)  # "Only for medicinal use"

vote_on(viktor,   nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(viktor,   psg_poll,      3)  # "No chance"
vote_on(viktor,   alice_poll,    0)  # "Yes, significantly"

vote_on(sofia,    france_poll,   0)  # "Yes, significantly"
vote_on(sofia,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(sofia,    alice_poll,    1)  # "Yes, moderately"

vote_on(anders,   nuclear_poll,  2)  # "No, renewables are enough"
vote_on(anders,   lights_poll,   2)  # "No, save electricity"
vote_on(anders,   carlos_poll,   1)  # "Hybrid is best"

vote_on(fatima,   psg_poll,      1)  # "Maybe, it's possible"
vote_on(fatima,   weekends_poll, 0)  # "Yes, absolutely"
vote_on(fatima,   bob_poll,      1)  # "Only for medicinal use"

vote_on(kofi,     nuclear_poll,  1)  # "Only as a transition energy"
vote_on(kofi,     lights_poll,   1)  # "Only in certain rooms"
vote_on(kofi,     carlos_poll,   2)  # "Office is better"

vote_on(maria,    france_poll,   0)  # "Yes, significantly"
vote_on(maria,    bob_poll,      0)  # "Yes, fully legalize"
vote_on(maria,    carlos_poll,   1)  # "Hybrid is best"

vote_on(dmitri,   nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(dmitri,   alice_poll,    0)  # "Yes, significantly"
vote_on(dmitri,   carlos_poll,   0)  # "Yes, remote is better"

vote_on(yaw,      lights_poll,   2)  # "No, save electricity"
vote_on(yaw,      bob_poll,      1)  # "Only for medicinal use"
vote_on(yaw,      carlos_poll,   2)  # "Office is better"

# --- 15 voter-only users ---
vote_on(lena,     nuclear_poll,  2)  # "No, renewables are enough"
vote_on(lena,     weekends_poll, 0)  # "Yes, absolutely"
vote_on(lena,     anders_poll,   0)  # "Yes, immediately"

vote_on(ahmed,    nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(ahmed,    psg_poll,      2)  # "Unlikely"
vote_on(ahmed,    amira_poll,    0)  # "Yes, it funds preservation"

vote_on(mei,      psg_poll,      1)  # "Maybe, it's possible"
vote_on(mei,      yuki_poll,     0)  # "Absolutely yes"
vote_on(mei,      liu_poll,      1)  # "Yes, but at a fair global pace"

vote_on(olga,     france_poll,   1)  # "Yes, but gradually"
vote_on(olga,     weekends_poll, 0)  # "Yes, absolutely"
vote_on(olga,     sofia_poll,    0)  # "Yes, for economic stability"

vote_on(jose,     bob_poll,      0)  # "Yes, fully legalize"
vote_on(jose,     carlos_poll,   1)  # "Hybrid is best"
vote_on(jose,     rafael_poll,   0)  # "Yes, to stop inflation"

vote_on(nadia,    nuclear_poll,  1)  # "Only as a transition energy"
vote_on(nadia,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(nadia,    amira_poll,    1)  # "Neutral, with proper management"

vote_on(kim,      lights_poll,   2)  # "No, save electricity"
vote_on(kim,      kofi_poll,     0)  # "Yes, like the Euro"
vote_on(kim,      yaw_poll,      1)  # "Balance both equally"

vote_on(boris,    france_poll,   0)  # "Yes, significantly"
vote_on(boris,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(boris,    sofia_poll,    0)  # "Yes, for economic stability"

vote_on(aisha,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(aisha,    fatima_poll,   0)  # "Yes, it's a great opportunity"
vote_on(aisha,    maria_poll,    1)  # "Yes, decriminalize only"

vote_on(pedro,    france_poll,   0)  # "Yes, significantly"
vote_on(pedro,    weekends_poll, 0)  # "Yes, absolutely"
vote_on(pedro,    thomas_poll,   0)  # "Yes, immediately"

vote_on(yara,     nuclear_poll,  1)  # "Only as a transition energy"
vote_on(yara,     amira_poll,    1)  # "Neutral, with proper management"
vote_on(yara,     dmitri_poll,   0)  # "Yes, immediately"

vote_on(mikael,   nuclear_poll,  0)  # "Yes, it's our best option"
vote_on(mikael,   weekends_poll, 0)  # "Yes, absolutely"
vote_on(mikael,   anders_poll,   0)  # "Yes, immediately"

vote_on(anya,     france_poll,   1)  # "Yes, but gradually"
vote_on(anya,     weekends_poll, 0)  # "Yes, absolutely"
vote_on(anya,     sofia_poll,    0)  # "Yes, for economic stability"

vote_on(chen,     psg_poll,      1)  # "Maybe, it's possible"
vote_on(chen,     carlos_poll,   1)  # "Hybrid is best"
vote_on(chen,     yuki_poll,     0)  # "Absolutely yes"

vote_on(zara,     bob_poll,      1)  # "Only for medicinal use"
vote_on(zara,     carlos_poll,   0)  # "Yes, remote is better"
vote_on(zara,     priya_poll,    0)  # "Yes, it's essential"

p "Seeded #{Poll.count} polls, #{PollOption.count} options, #{User.count} users, and #{Vote.count} votes"
