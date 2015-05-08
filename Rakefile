task :clean do
  sh 'rm -f cine/*.png'
  sh 'rm -f report.html entro.mp4 img/*.png'
  sh 'rm -f bit.png byte.png covariance.png pvalues.png'
  sh 'rm -f binomial.png qindependence.png runs.png gauss_sum.png'
end

task :test do
  sh './test/baseline.rb -v'
end

task :generators do
  gens = Dir.glob('lib/generators/*.rb').map { |x| File.basename(x) }
  gens.sort.each do |gen|
    sh "./bin/entrospect -l 16M -g #{gen.gsub('.rb', '').gsub('_', '')}"
  end
end
