<?php
$EM_CONF[$_EXTKEY] = [
    'title' => 'SONS Site Package',
    'description' => 'Custom site package for SONS Landingpage',
    'category' => 'template',
    'constraints' => [
        'depends' => [
            'typo3' => '12.0.0-12.9.99',
            'fluid_styled_content' => '12.0.0-12.9.99',
        ],
        'conflicts' => [],
    ],
    'state' => 'stable',
    'clearCacheOnLoad' => 1,
    'version' => '1.0.0',
];
