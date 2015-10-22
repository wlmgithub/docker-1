# Constants
IPV6_ADDR ||= /(
([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|
([0-9a-fA-F]{1,4}:){1,7}:|
([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|
([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|
([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|
([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|
([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|
[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|
:((:[0-9a-fA-F]{1,4}){1,7}|:)|
fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|
::(ffff(:0{1,4}){0,1}:){0,1}
((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|
([0-9a-fA-F]{1,4}:){1,4}:
((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])
)/

IPV4_ADDR ||= /((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])/

IPV6_CIDR ||= /s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:)))(%.+)?s*/

IPV4_CIDR ||= %r{(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))}

module DockerCookbook
  module DockerHelpers
    module Service
      def connect_host
        return nil unless host
        sorted = coerce_host(host).sort do |a, b|
          c_a = 1 if a =~ /^unix:/
          c_a = 2 if a =~ /^fd:/
          c_a = 3 if a =~ %r{^tcp://127.0.0.1:}
          c_a = 4 if a =~ %r{^tcp://(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*:}
          c_a = 5 if a =~ %r{^tcp://0.0.0.0:}
          c_a = 6 unless c_a
          c_b = 1 if b =~ /^unix:/
          c_b = 2 if b =~ /^fd:/
          c_b = 3 if b =~ %r{^tcp://127.0.0.1:}
          c_b = 4 if b =~ %r{^tcp://(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*:}
          c_b = 5 if b =~ %r{^tcp://0.0.0.0:}
          c_b = 6 unless c_b
          c_a <=> c_b
        end
        if sorted.first =~ %r{^tcp://0.0.0.0:}
          r = sorted.first.match(%r{(?<proto>.*)://(?<socket>[^:]+):?(?<port>\d+)?})
          return "tcp://127.0.0.1:#{r['port']}"
        end
        sorted.first
      end

      def docker_kernel
        node['kernel']['name']
      end

      def docker_arch
        node['kernel']['machine']
      end

      def coerce_host(v)
        v = v.split if v.is_a?(String)
        Array(v).each_with_object([]) do |s, r|
          if s.match(/^unix:/) || s.match(/^tcp:/) || s.match(/^fd:/)
            r << s
          else
            Chef::Log.info("WARNING: docker_service host property #{s} not valid")
          end
        end
      end

      def coerce_daemon_labels(v)
        Array(v).each_with_object([]) do |label, a|
          parts = label.split(':')
          a << "#{parts[0]}=\"#{parts[1]}\""
        end
      end

      def default_checksum
        case docker_kernel
        when 'Darwin'
          case version
          when '1.6.0' then '9e960e925561b4ec2b81f52b6151cd129739c1f4fba91ce94bdc0333d7d98c38'
          when '1.6.2' then 'f29b8b2185c291bd276f7cdac45a674f904e964426d5b969fda7b8ef6b8ab557'
          when '1.7.0' then '1c8ee59249fdde401afebc9a079cb75d7674f03d2491789fb45c88020a8c5783'
          when '1.7.1' then 'b8209b4382d0b4292c756dd055c12e5efacec2055d5900ac91efc8e81d317cf9'
          when '1.8.1' then '0f5db35127cf14b57614ad7513296be600ddaa79182d8d118d095cb90c721e3a'
          when '1.8.2' then 'cef593612752e5a50bd075931956075a534b293b7002892072397c3093fe11a6'
          end
        when 'Linux'
          case version
          when '1.6.0' then '526fbd15dc6bcf2f24f99959d998d080136e290bbb017624a5a3821b63916ae8'
          when '1.6.2' then 'e131b2d78d9f9e51b0e5ca8df632ac0a1d48bcba92036d0c839e371d6cf960ec'
          when '1.7.1' then '4d535a62882f2123fb9545a5d140a6a2ccc7bfc7a3c0ec5361d33e498e4876d5'
          when '1.8.1' then '843f90f5001e87d639df82441342e6d4c53886c65f72a5cc4765a7ba3ad4fc57'
          when '1.8.2' then '97a3f5924b0b831a310efa8bf0a4c91956cd6387c4a8667d27e2b2dd3da67e4d'
          end
        end
      end

      def default_source
        "https://get.docker.com/builds/#{docker_kernel}/#{docker_arch}/docker-#{version}"
      end

      def default_version
        if node['platform'] == 'amazon' ||
           node['platform'] == 'ubuntu' && node['platform_version'].to_f < 15.04 ||
           node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7 ||
           node['platform_family'] == 'debian' && node['platform_version'].to_i <= 7
          '1.6.2'
        else
          '1.8.2'
        end
      end

      # Path to docker executable
      def docker_bin
        '/usr/bin/docker'
      end

      def docker_major_version
        ray = version.split('.')
        ray.pop
        ray.push.join('.')
      end

      def docker_daemon_arg
        if docker_major_version.to_f < 1.8
          '-d'
        else
          'daemon'
        end
      end

      def docker_daemon_cmd
        [docker_bin, docker_daemon_arg, docker_daemon_opts].join(' ')
      end

      def docker_cmd
        [docker_bin, docker_opts].join(' ')
      end

      def docker_opts
        opts = []
        opts << "--host=#{connect_host}" if connect_host
        if connect_host =~ /^tcp:/
          opts << "--tls=#{tls}" unless tls.nil?
          opts << "--tlsverify=#{tls_verify}" unless tls_verify.nil?
          opts << "--tlscacert=#{tls_ca_cert}" if tls_ca_cert
          opts << "--tlscert=#{tls_client_cert}" if tls_client_cert
          opts << "--tlskey=#{tls_client_key}" if tls_client_key
        end
        opts
      end

      def docker_daemon_opts
        opts = []
        opts << "--api-cors-header=#{api_cors_header}" if api_cors_header
        opts << "--bridge=#{bridge}" if bridge
        opts << "--bip=#{bip}" if bip
        opts << '--debug' if debug
        default_ulimit.each { |u| opts << "--default-ulimit=#{u}" } if default_ulimit
        dns.each { |dns| opts << "--dns=#{dns}" } if dns
        dns_search.each { |dns| opts << "--dns-search=#{dns}" } if dns_search
        opts << "--exec-driver=#{exec_driver}" if exec_driver
        opts << "--fixed-cidr=#{fixed_cidr}" if fixed_cidr
        opts << "--fixed-cidr-v6=#{fixed_cidr_v6}" if fixed_cidr_v6
        opts << "--group=#{group}" if group
        opts << "--graph=#{graph}" if graph
        host.each { |h| opts << "-H #{h}" } if host
        opts << "--icc=#{icc}" unless icc.nil?
        opts << "--insecure-registry=#{insecure_registry}" if insecure_registry
        opts << "--ip=#{ip}" if ip
        opts << "--ip-forward=#{ip_forward}" unless ip_forward.nil?
        opts << "--ip-masq=#{ip_masq}" unless ip_masq.nil?
        opts << "--iptables=#{iptables}" unless iptables.nil?
        opts << "--ipv6=#{ipv6}" unless ipv6.nil?
        opts << "--log-level=#{log_level}" if log_level
        labels.each { |l| opts << "--label=#{l}" } if labels
        opts << "--log-driver=#{log_driver}" if log_driver
        log_opts.each { |log_opt| opts << "--log-opt=#{log_opt}" } if log_opts
        opts << "--mtu=#{mtu}" if mtu
        opts << "--pidfile=#{pidfile}" if pidfile
        opts << "--registry-mirror=#{registry_mirror}" if registry_mirror
        storage_driver.each { |s| opts << "--storage-driver=#{s}" } if storage_driver
        opts << "--selinux-enabled=#{selinux_enabled}" unless selinux_enabled.nil?
        storage_opts.each { |storage_opt| opts << "--storage-opt=#{storage_opt}" } if storage_opts
        opts << "--tls=#{tls}" unless tls.nil?
        opts << "--tlsverify=#{tls_verify}" unless tls_verify.nil?
        opts << "--tlscacert=#{tls_ca_cert}" if tls_ca_cert
        opts << "--tlscert=#{tls_server_cert}" if tls_server_cert
        opts << "--tlskey=#{tls_server_key}" if tls_server_key
        opts << "--userland-proxy=#{userland_proxy}" unless userland_proxy.nil?
        opts
      end

      def docker_running?
        o = shell_out("#{docker_cmd} ps | head -n 1 | grep ^CONTAINER")
        return true if o.stdout =~ /CONTAINER/
        false
      end
    end
  end
end
