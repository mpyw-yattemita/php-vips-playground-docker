<?php

declare(strict_types=1);

namespace App;

use Jcupitt\Vips\Image;
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
        $sources = array_map(
            fn (string $filename) => Image::newFromFile($filename),
            [$input->getArgument('source'), ...$input->getArgument('sources')],
        );

        Image::arrayjoin($sources)->copy()->writeToFile($input->getArgument('destination'), []);

        return 0;
    }
}
