require 'spec_helper'

describe Ricer4::Plugins::Math do
  
  # LOAD
  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run

  it("calculates correctly") do
    expect(bot.exec_line_for("Math/Calc", "4 + 4")).to eq("8")
  end

  it("has a working avg function") do
    expect(bot.exec_line_for("Math/Avg", "4,8,6")).to start_with("6")
  end

  it("produces predictable random numbers") do
    
  end
  
end
