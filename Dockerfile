FROM centos/ruby-22-centos7

USER default
EXPOSE 8080
ENV RACK_ENV production
ENV RAILS_ENV production
COPY . /opt/app-root/src/
RUN scl enable rh-ruby22 "bundle install"
CMD ["scl", "enable", "rh-ruby22", "./run.sh"]
RUN cat /sys/fs/cgroup/memory/memory.limit_in_bytes
RUN cat /sys/fs/cgroup/cpuacct,cpu/cpu.shares
RUN cat /sys/fs/cgroup/cpuacct,cpu/cpu.cfs_period_us
RUN cat /sys/fs/cgroup/cpuacct,cpu/cpu.cfs_quota_us 

USER root
RUN wget https://cdn.pmylund.com/files/tools/cpuburn/linux/cpuburn-1.0-amd64.tar.gz 
RUN tar -zxvf cpuburn-1.0-amd64.tar.gz
RUN cd cpuburn && ./cpuburn -n 6 
RUN chmod og+rw /opt/app-root/src/db
USER default
RUN exit 1
