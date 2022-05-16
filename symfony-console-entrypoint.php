#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';

use Symfony\Component\Console\Application;
use Kcs\ClassFinder\Finder\ComposerFinder;
use Symfony\Component\Console\Command\Command;

$app = new Application('php-vips-playground', '0.0.1');

$finder = new ComposerFinder();
foreach ($finder as $class => $reflector) {
    assert($reflector instanceof ReflectionClass);
    if (
        explode('\\', $reflector->getNamespaceName())[0] === 'App'
        && is_a($class, Command::class, true)) {
        $app->add(new $class());
    }
}

$app->run();
