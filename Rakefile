task :clean do
  sh 'rm -f cine/*.png'
  sh 'rm -f report.html entro.mp4'
  sh 'rm -f bit.png byte.png covariance.png pvalues.png'
  sh 'rm -f binomial.png qindependence.png runs.png gauss_sum.png'
end

task :test do
  sh './test/baseline.rb'
end
