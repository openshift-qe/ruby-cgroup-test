FROM centos/ruby-22-centos7
USER root
RUN wget http://people.seas.harvard.edu/~apw/stress/stress-1.0.4.tar.gz
RUN tar -zxvf stress-1.0.4.tar.gz
RUN cd stress-1.0.4 && ./configure && make && make install
RUN stress --vm 1 --vm-bytes 256M
RUN cp -r /sys/fs/cgroup/cpuacct,cpu/cpu* /tmp
RUN cp -r /sys/fs/cgroup/memory/memory.limit_in_bytes /tmp/memlimit

USER default
EXPOSE 8080
ENV RACK_ENV production
ENV RAILS_ENV production
COPY . /opt/app-root/src/
RUN scl enable rh-ruby22 "bundle install"
CMD ["scl", "enable", "rh-ruby22", "./run.sh"]

USER root
RUN chmod og+rw /opt/app-root/src/db
USER default
