class Exception
  alias_method :old_backtrace, :backtrace
  def backtrace  
    if old_backtrace.nil?
      nil
    else
      old_backtrace.map do |x|
        x.rpartition('/gems/')[-2,2]
         .join('')
         .gsub(%r{/Users/([^/]*)/}, '~/')
         .gsub(%r{/home/([^/]*)/}, '~/')
      end
    end
  end
end
