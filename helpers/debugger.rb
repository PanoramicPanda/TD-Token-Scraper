class TDDebugger

  def initialize(debug_mode = false)
    @debug = debug_mode
    @start_time = ''
  end

  def debug_message(text)
    puts "[DEBUGGER]->  #{text}" if @debug
  end

  def start_time
    @start_time = Time.now if @debug
  end

  def elapsed_time(task)
    debug_message("#{task} took #{time_string((Time.now - @start_time).to_i)}") if @debug
  end

  def time_string(total_time)
    hours = total_time >= 3600 ? total / 3600 : 0
    under_hour_seconds = hours == 0 ? total_time : total_time % 3600
    minutes = under_hour_seconds >= 60 ? total_time / 60 : 0
    seconds = total_time - (minutes * 60) - (hours * 3600)

    composite = ''
    composite += "#{hours} hours, " if hours != 0
    composite += "#{minutes} minutes, " if minutes != 0
    composite += "and " if hours != 0 || minutes != 0
    composite += "#{seconds} seconds"
    composite
  end

end