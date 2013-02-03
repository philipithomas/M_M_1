

class M_M_1 
	def initialize( mu, lambda, trials )

		# Set inter-arrival time constant
		@LAMBDA = lambda

		# Set service time constant
		@MU = mu

		# Start the time, number in queue, count, and L integral to zero 
		@time, @l, @count, @accum =0



		# and set the trials (count limit) 
		@TRIALS = trials

		# Get the first arrival time
		@next_arrival=get_interarrival_time

		# Nobody in queue, so next departure is nil
		@next_departure = nil

	

		while ( @count < @trials )
			if ( @next_arrival < @next_departure  || @next_departure.nil?)
				process_arrival
			else
				process_departure
			end
		end


	end

	def get_interarrival_time
		-1 / @LAMBDA * Math.log( 1 - rand( 1 ) )
	end

	def process_arrival
		# First increase the integral
		@accum += @l * ( @next_arrival - @time )
		
		# increment the number in the queue
		@l += 1

		# Advance time to the next arrival 
		@time = @next_arrival

		# Generate the next arrival time
		@next_arrival = @time + get_interarrival_time
	end

	def get_service_time
		-1 / @MU * Math.log( 1-rand( 1 ) )

	end

	def process_departure
		@accum += @l * ( @next_arrival - @time )

		@time = @next_departure

		if ( @l > 0 )
			@next_departure = @time + get_service_time
		else 
			@next_departure = nil
		end


	end

	def stats
		# Displays statistics on the simulation
		puts " M/M/1 Simulation Summary"
		puts "Inter-arrival time: #{@LAMDA}"
		puts "Service time: #{@MU}"

		rho = @lambda / @mu

		puts "Traffic intensity: #{rho}"

		

	end

end

