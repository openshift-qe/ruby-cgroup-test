FROM centos/ruby-22-centos7

USER default
EXPOSE 8080
ENV RACK_ENV production
ENV RAILS_ENV production
COPY . /opt/app-root/src/
RUN scl enable rh-ruby22 "bundle install"
CMD ["scl", "enable", "rh-ruby22", "./run.sh"]

USER root
RUN chmod og+rw /opt/app-root/src/db
RUN wget https://cdn.pmylund.com/files/tools/cpuburn/linux/cpuburn-1.0-amd64.tar.gz 
RUN tar -zxvf cpuburn-1.0-amd64.tar.gz
RUN cd cpuburn & ./cpuburn -n 1
RUN cp -r /sys/fs/cgroup/cpuacct,cpu/cpu* /tmp
RUN cp -r /sys/fs/cgroup/memory/memory.limit_in_bytes /tmp/memlimit
USER default
