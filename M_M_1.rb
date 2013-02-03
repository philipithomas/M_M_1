
class MM1_Simulation 
	def initialize( arrival_time, departure_time, trials )

		# Set inter-arrival time constant
		@LAMBDA = 1/arrival_time.to_f

		# Set service time constant
		@MU = 1/departure_time.to_f

		# Start the time, number in queue, count, and L integral to zero 
		@time, @l, @count, @accum = 0, 0, 0, 0



		# and set the trials (count limit) 
		@TRIALS = trials

		# Get the first arrival time
		@next_arrival= get_interarrival_time

		# Nobody in queue, so next departure is nil
		@next_departure = nil
		
		return true	

	end

	def run 
		while ( @count < @TRIALS )
			# puts "#{ @count}, #{@time},  #{@next_arrival}"

			if ( @next_departure.nil? || @next_arrival < @next_departure )
				self.process_arrival
			else
				self.process_departure
			end
		end

		while ( @l > 0 )
			self.process_departure
		end

		self.stats

	end


	def get_interarrival_time
		-1.to_f / @LAMBDA * Math.log( 1 - rand )
	end

	def process_arrival
		@count +=1 

		# First increase the integral
		@accum += @l * ( @next_arrival - @time )
		
		# increment the number in the queue
		@l += 1

		# Advance time to the next arrival 
		@time = @next_arrival

		# Generate the next arrival time
		@next_arrival = @time + get_interarrival_time

		if @l>0
			@next_departure = @time + get_service_time
		end

	end

	def get_service_time
		-1.to_f / @MU * Math.log( 1-rand )

	end

	def process_departure
		@accum += @l * ( @next_arrival - @time )

		@l -= 1

		@time = @next_departure

		if ( @l > 0 )
			@next_departure = @time + self.get_service_time
		else 
			@next_departure = nil
		end


	end

	def stats
		# Displays statistics on the simulation
		puts "M/M/1 Simulation Summary"
		puts "Iterations: #{@count}"
		puts "Arrival Rate: #{@LAMBDA}"
		puts "Max Service Rate: #{@MU}"

		rho = @LAMBDA.to_f / @MU.to_f

		puts "Traffic intensity: #{rho}"

		puts "Average number in system: #{@accum.to_f/@time.to_f}"


		

	end

end


tiny = MM1_Simulation.new(15,12,1000).run

