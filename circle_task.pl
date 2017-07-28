#!/usr/bin/perl
use utf8;
use strict;
use warnings;

use SimpleDBI;
use Data::Dumper;

my $db = SimpleDBI->new(
    type => 'mysql', 
    db     => 'mydb',
    host   => 'localhost',
    usr    => 'myusr',
    passwd => 'mypwd',
    port => 3306, 
);

my $task_table = 'ip_loc_task';

my @worker = qw/ 
work1.xxx.com
/;

for my $w (@worker){
    print "check worker $w\n";
    main_task($db, $task_table, $w, 'ask_ip_loc.pl', \&remote_action);
}

sub remote_action {
    my ($worker, $task) = @_;
    print "worker $worker, task $task\n";
    system(qq[ansible $worker -m shell -a 'cd /root/ask_ip_loc ; nohup perl ask_ip_loc.pl $task &']);
}

sub main_task {
    my ($db, $task_table, $worker, $keyword, $act_sub) = @_;

    my $can_work = check_worker_status($worker, $keyword);
    return unless($can_work);

    my $task = alloc_worker_task($db, $task_table, $worker);
    return unless($task);

    $act_sub->($worker, $task);
}

sub check_worker_status {
    my ($worker, $keyword) = @_;
    my $c=`ansible $worker -m shell -a 'ps aux|grep $keyword |grep -v grep'`;
    print $c, "\n";
    return unless($c); # fail connect $worker
    #return if($c=~/FAILED/s and $c=~/rc\=1/s); #not working
    return if($c=~/SUCCESS/s and $c=~/rc\=0/s); #working
    return $worker; # can work
}

sub alloc_worker_task {
    my ($db, $task_table, $worker) = @_;

    $db->{dbh}->do(qq{update $task_table set worker=NULL where worker='$worker' });

    my $data = $db->query_db(qq[select task from $task_table where worker is NULL order by time asc limit 1], 
        result_type => 'arrayref', 
    );
    if(@$data){
        my $task=$data->[0][0];
        $db->{dbh}->do(qq{update $task_table set worker='$worker' where task='$task' });
        print "select task $task\n";
        return $task;
    }

    return;
}
