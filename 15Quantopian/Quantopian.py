# TUTORIAL 1 - Getting Started
#0 sample
def initialize(context):
    # Reference to AAPL
    context.aapl = sid(24)
def handle_data(context, data): 
    # Position 100% of our portfolio to be long in AAPL
    order_target_percent(context.aapl, 1.00)
#1 initialize(), handle_data()
def initialize(context):
    context.message = 'hello'
def handle_data(context, data):
	#prints message per minute.
    print context.message
#2 before_trading_start() is called once per day before the market opens 
#3 pipeline (auto trade)
#4 sid()
def initialize(context):
    context.aapl = sid(24)
#5 symbol(), set_symbol_lookup_date('YYYY-MM-DD')
#lesson4
#6 order_target_percent()
order_target_percent(sid(24), 0.50)
order_target_percent(sid(24), -0.50)
def initialize(context):
    context.aapl = sid(24)
    context.spy = sid(8554)
def handle_data(context, data):
    # Note: data.can_trade() is explained in the next lesson
    if data.can_trade(context.aapl):
        order_target_percent(context.aapl, 0.60)
    if data.can_trade(context.spy):
        order_target_percent(context.spy, -0.40)
#lesson5
#7 data, data.current(), data.can_trade()
#'price', 'open', 'high', 'low', 'close', and 'volume'
data.current(sid(24), 'price')
data.current([sid(24), sid(8554)], 'price')
data.current([sid(24), sid(8554)], ['low', 'high'])
data.can_trade(sid(24))
#lesson6
#8 data.history()
#'price', 'open', 'high', 'low', 'close', and 'volume'
#'1d', '1m'
hist = data.history(sid(24), 'price', 10, '1d')
mean_price = hist.mean()
#the last 10 complete days
data.history(sid(8554), 'volume', 11, '1d')[:-1].mean()
# Example 1
# Get the last 5 minutes of volume data for each security in our list.
hist = data.history([sid(24), sid(8554), sid(5061)], 'volume', 5, '1m')
# Calculate the mean volume for each security in our DataFrame.
mean_volumes = hist.mean(axis=0)
# Example 2
# Low and high minute bar history for each of our securities.
hist = data.history([sid(24), sid(8554), sid(5061)], ['low', 'high'], 5, '1m')
# Calculate the mean low and high over the last 5 minutes
means = hist.mean()
mean_lows = means['low']
mean_highs = means['high']
# Example 3
def initialize(context):
    # AAPL, MSFT, SPY
    context.security_list = [sid(24), sid(8554), sid(5061)]
def handle_data(context, data):
    hist = data.history(context.security_list, 'volume', 10, '1m').mean()
    print hist.mean()
#lesson7
#the US Equities Calendar and the US Futures Calendar.
#9 schedule_function(), rebalance()
schedule_function(func=rebalance,
                  date_rules=date_rules.every_day(),
                  time_rules=time_rules.market_open(hours=1))
schedule_function(weekly_trades, 
				  date_rules.week_end(), 
				  time_rules.market_close(minutes=30))
# Example 1
def initialize(context):
    context.spy = sid(8554)

    schedule_function(open_positions, date_rules.week_start(), time_rules.market_open())
    schedule_function(close_positions, date_rules.week_end(), time_rules.market_close(minutes=30))
#half_days=False 
def open_positions(context, data):
    order_target_percent(context.spy, 0.10)

def close_positions(context, data):
    order_target_percent(context.spy, 0)

#lesson8
#10 positions
for security in context.portfolio.positions:
  order_target_percent(security, 0)
#11 record()
def initialize(context):
    context.aapl = sid(24)
    context.spy = sid(8554)
    schedule_function(rebalance, date_rules.every_day(), time_rules.market_open())
    schedule_function(record_vars, date_rules.every_day(), time_rules.market_close())
def rebalance(context, data):
    order_target_percent(context.aapl, 0.50)
    order_target_percent(context.spy, -0.50)
def record_vars(context, data):
    long_count = 0
    short_count = 0
    for position in context.portfolio.positions.itervalues():
        if position.amount > 0:
            long_count += 1
        if position.amount < 0:
            short_count += 1
    # Plot the counts
    record(num_long=long_count, num_short=short_count)
#lesson9
#12 set_slippage)()
set_slippage(slippage.VolumeShareSlippage(volume_limit=0.025, price_impact=0.1))
#13 set_commission()
set_commission(commission.PerShare(cost=0.001, min_trade_cost=1))
#lesson10
#14 get_open_orders() 
def initialize(context):
    # Relatively illiquid stock.
    context.xtl = sid(40768)
def handle_data(context, data):
    # Get all open orders.
    open_orders = get_open_orders()
    if context.xtl not in open_orders and data.can_trade(context.xtl):
        order_target_percent(context.xtl, 1.0)
#lesson11 Putting It All Together

# TUTORIAL 2 - Pipline
#lesson1 









































