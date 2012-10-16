class Stats
  def self.statsd=(statsd)
    @statsd = statsd
  end

  def self.increment(key, by = 1)
    @statsd.increment(key, by)
  end

  def self.timing(key, value)
    @statsd.timing(key, value)
  end
end
