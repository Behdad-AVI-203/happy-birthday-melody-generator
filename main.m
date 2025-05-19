note_names = {'Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Si', 'Do2'};
frequencies = zeros(1, length(note_names));
note_folder = 'project_Part1/8 named white notes';

for i = 1:length(note_names)
    file_path = fullfile(note_folder, [note_names{i}, '.wav']);

    if ~exist(file_path, 'file')
        error('File not found: %s', file_path);
    end

    [audio, Fs] = audioread(file_path);
    N = length(audio);
    Y = fft(audio);
    f = (0:N-1)*(Fs/N);
    magnitude = abs(Y);
    [~, idx] = max(magnitude);
    frequencies(i) = f(idx);
    fprintf('Note: %s, Frequency: %.2f Hz\n', note_names{i}, frequencies(i));
end

song_folder = 'project_Part1/26 notes of happy birthday';
frequencies_26 = zeros(1, 26);
note_labels = strings(1, 26);

for i = 1:26
    file_name = fullfile(song_folder, [num2str(i), '.wav']);

    if ~exist(file_name, 'file')
        error('File not found: %s', file_name);
    end

    [audio, Fs] = audioread(file_name);
    N = length(audio);
    Y = fft(audio);
    f = (0:N-1)*(Fs/N);
    magnitude = abs(Y);
    [~, idx] = max(magnitude);
    frequencies_26(i) = f(idx);
    [~, note_idx] = min(abs(frequencies - f(idx)));
    note_labels(i) = note_names{note_idx};
    fprintf('Note %d: %s, Frequency: %.2f Hz\n', i, note_labels(i), frequencies_26(i));
end

tempo = 2;

happy_birthday_notes = {'Sol', 'Sol', 'Do2', 'Sol', 'Sol', 'Do2', ...
    'Sol', 'Sol', 'Do2', 'Do2', 'Si', 'La', ...
    'Si', 'Sol', 'Sol', 'Si', 'Sol', 'Sol', ...
    'Si', 'Sol', 'Sol', 'La', 'Sol', 'La', ...
    'Do2', 'Do2'};
happy_birthday_durations = [1/8, 1/4, 3/8, 1/8, 1/4, 3/8, ...
    1/8, 1/4, 1/8, 1/4, 1/8, 1/4, ...
    3/8, 1/8, 1/4, 3/8, 1/8, 1/4, ...
    3/8, 1/8, 1/4, 1/8, 1/4, 1/8, ...
    1/4, 3/8] * tempo;

Fs_out = 44100;
output_song = [];

for i = 1:length(happy_birthday_notes)
    note_idx = find(strcmp(note_names, happy_birthday_notes{i}));
    if isempty(note_idx)
        error('Note %s not found in note_names', happy_birthday_notes{i});
    end
    note_freq = frequencies(note_idx);
    duration = happy_birthday_durations(i);
    t = 0:1/Fs_out:duration-1/Fs_out;
    note_wave = sin(2*pi*note_freq*t);
    output_song = [output_song, note_wave];
end

output_song = output_song / max(abs(output_song));
sound(output_song, Fs_out);
audiowrite('project_Part1/Happy_Birthday_Reconstructed.wav', output_song, Fs_out);
fprintf('Happy Birthday song reconstruction completed!\n');

