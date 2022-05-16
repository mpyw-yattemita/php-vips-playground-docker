<?php

declare(strict_types=1);

namespace App;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class ExampleCommand extends Command
{
    protected function configure(): void
    {
        $this
            ->setName('example')
            ->setDescription('This is an example command');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln('Example');

        return 0;
    }
}
