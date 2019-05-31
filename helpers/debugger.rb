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
    debug_message("#{task} took #{(Time.now - @start_time).to_i} seconds") if @debug
  end

end