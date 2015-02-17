Pod::Spec.new do |s|

    s.name              = 'JLImageDownload'
    s.version           = '1.0'
    s.summary           = 'A class that handles image download using completion blocks (GCD) and can work hand in hand with operation queues'
    s.homepage          = 'https://github.com/joshuaLareta/JLImageDownload'
    s.license           = 'MIT'
    s.platform			= :ios,'7.0'
       
    s.author            = {
        'Joshua Lareta' => 'joshua.lareta@gmail.com'
    }
    s.source            = {
        :git => 'https://github.com/joshuaLareta/JLImageDownload.git',
        :tag => '1.0'
    }
    s.source_files      = 'Example/Example/Class/*.{m,h}'
    s.requires_arc      = true

end