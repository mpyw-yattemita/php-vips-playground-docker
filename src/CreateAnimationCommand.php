<?php

declare(strict_types=1);

namespace App;

use Imagine\Vips\Imagine;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class CreateAnimationCommand extends Command
{
    protected function configure(): void
    {
        $this
            ->setName('gif:animation:create')
            ->setDescription('Create animation from frame files')
            ->addArgument(
                'destination',
                InputArgument::REQUIRED,
            )
            ->addArgument(
                'source',
                InputArgument::REQUIRED,
            )
            ->addArgument(
                'sources',
                InputArgument::IS_ARRAY,
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $imagine = new Imagine();

        $image = $imagine->open($input->getArgument('source'));

        foreach ($input->getArgument('sources') as $argument) {
            $image->layers()->add($imagine->open($argument));
        }

        $image->save($input->getArgument('destination'), array(
            'animated' => true,
        ));

        return 0;
    }
}
