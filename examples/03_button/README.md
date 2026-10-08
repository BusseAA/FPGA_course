# Включение светодиода по нажатию кнопки
Задача: нажатие кнопки (событие нажатия) включает и выключает светодиод.

## Timing constraints
* В обычном проекте создаем *.sdc файл File->New->Synopsys design constraints
* Здесь же они уже созданы за вас (button.sdc). 
  - добавьте их либо на этапе создания проекта
  - либо через Assignments->settings->Files.

## Анализ MTBFS
Quartus может посчитать вам MTBF для всех синхронизаторов в дизайне:
* В Assignments->Settings->Timing Analyzer->Synchronizer identification установите в Force if asynchronous
* После синтеза в разделе Timing Analyzer->Сценарий(например 1200 slow)-> metastability summary
